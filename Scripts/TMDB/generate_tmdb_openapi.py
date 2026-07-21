#!/usr/bin/env python3

import json
import keyword
import re
import urllib.request
from pathlib import Path


SPEC_URL = "https://developer.themoviedb.org/openapi/tmdb-api.json"
SOURCE_OUTPUT = Path("MovieApp/Data/TMDB/Generated/TMDBGeneratedAPI.swift")
TEST_OUTPUT = Path("MovieAppTests/TMDB/TMDBGeneratedAPISuite.swift")


SWIFT_KEYWORDS = {
    "associatedtype", "class", "deinit", "enum", "extension", "fileprivate",
    "func", "import", "init", "inout", "internal", "let", "open", "operator",
    "private", "protocol", "public", "rethrows", "static", "struct",
    "subscript", "typealias", "var", "break", "case", "continue", "default",
    "defer", "do", "else", "fallthrough", "for", "guard", "if", "in",
    "repeat", "return", "switch", "where", "while", "as", "Any", "catch",
    "false", "is", "nil", "super", "self", "Self", "throw", "throws",
    "true", "try"
}


def fetch_spec():
    request = urllib.request.Request(
        SPEC_URL,
        headers={"User-Agent": "MovieApp-TMDB-OpenAPI-Generator/1.0"},
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        return json.loads(response.read())


def words(value):
    value = re.sub(r"[^A-Za-z0-9]+", " ", value)
    return [word for word in value.strip().split() if word]


def pascal(value):
    return "".join(word[:1].upper() + word[1:] for word in words(value))


def camel(value):
    parts = words(value)
    if not parts:
        return "value"
    head = parts[0][:1].lower() + parts[0][1:]
    tail = "".join(word[:1].upper() + word[1:] for word in parts[1:])
    result = head + tail
    if keyword.iskeyword(result) or result in SWIFT_KEYWORDS:
        return f"{result}Value"
    if result[:1].isdigit():
        return f"value{result}"
    return result


def string_literal(value):
    return json.dumps(value)


def swift_type_for_primitive(schema):
    schema_type = schema.get("type")
    if isinstance(schema_type, dict):
        schema_type = schema_type.get("type")
    if schema_type == "string":
        return "String"
    if schema_type == "integer":
        return "Int"
    if schema_type == "number":
        return "Double"
    if schema_type == "boolean":
        return "Bool"
    return "TMDBJSONValue"


class SchemaGenerator:
    def __init__(self):
        self.structs = []
        self.generated = set()

    def type_for(self, schema, name):
        if not schema:
            return "TMDBJSONValue"

        schema_type = schema.get("type")
        if isinstance(schema_type, dict):
            schema_type = schema_type.get("type")

        if schema_type == "array":
            item_type = self.type_for(schema.get("items") or {}, f"{name}Item")
            return f"[{item_type}]"

        if schema_type == "object" or "properties" in schema:
            type_name = pascal(name) or "TMDBGeneratedObject"
            self.emit_struct(type_name, schema)
            return type_name

        return swift_type_for_primitive(schema)

    def emit_struct(self, name, schema):
        if name in self.generated:
            return
        self.generated.add(name)

        properties = schema.get("properties") or {}
        lines = [f"struct {name}: Codable, Equatable {{"]

        if not properties:
            lines.append("    let additionalProperties: [String: TMDBJSONValue]?")
            lines.append("")
            lines.append("    init(additionalProperties: [String: TMDBJSONValue]? = nil) {")
            lines.append("        self.additionalProperties = additionalProperties")
            lines.append("    }")
            lines.append("}")
            self.structs.append("\n".join(lines))
            return

        coding_keys = []
        init_args = []
        init_assignments = []
        decode_lines = []
        encode_lines = []
        used_property_names = set()

        for raw_name, property_schema in properties.items():
            property_name = camel(raw_name)
            if property_name in used_property_names:
                base_name = f"{property_name}{pascal(raw_name) or 'Value'}"
                property_name = base_name
                index = 2
                while property_name in used_property_names:
                    property_name = f"{base_name}{index}"
                    index += 1
            used_property_names.add(property_name)
            property_type = self.type_for(property_schema or {}, f"{name}{pascal(raw_name)}")
            lines.append(f"    let {property_name}: {property_type}?")
            coding_keys.append((property_name, raw_name))
            init_args.append(f"{property_name}: {property_type}? = nil")
            init_assignments.append(f"        self.{property_name} = {property_name}")
            decode_lines.append(f"        {property_name} = try container.decodeIfPresent({property_type}.self, forKey: .{property_name})")
            encode_lines.append(f"        try container.encodeIfPresent({property_name}, forKey: .{property_name})")

        lines.append("")
        lines.append("    enum CodingKeys: String, CodingKey {")
        for property_name, raw_name in coding_keys:
            lines.append(f"        case {property_name} = {string_literal(raw_name)}")
        lines.append("    }")
        lines.append("")
        lines.append("    init(")
        for index, arg in enumerate(init_args):
            suffix = "," if index < len(init_args) - 1 else ""
            lines.append(f"        {arg}{suffix}")
        lines.append("    ) {")
        lines.extend(init_assignments)
        lines.append("    }")
        lines.append("")
        lines.append("    init(from decoder: Decoder) throws {")
        lines.append("        let container = try decoder.container(keyedBy: CodingKeys.self)")
        lines.extend(decode_lines)
        lines.append("    }")
        lines.append("")
        lines.append("    func encode(to encoder: Encoder) throws {")
        lines.append("        var container = encoder.container(keyedBy: CodingKeys.self)")
        lines.extend(encode_lines)
        lines.append("    }")
        lines.append("}")

        self.structs.append("\n".join(lines))


def operation_name(operation, method, path):
    operation_id = operation.get("operationId")
    if operation_id:
        return pascal(operation_id)
    return pascal(f"{method} {path}")


def path_without_version(path):
    return path[2:] if path.startswith("/3") else path


def swift_param_type(parameter):
    schema = parameter.get("schema") or {}
    return swift_type_for_primitive(schema)


def make_operations(spec, schemas):
    operations = []
    for path, methods in spec["paths"].items():
        for method, operation in methods.items():
            if method not in {"get", "post", "delete", "put", "patch"}:
                continue

            op_name = operation_name(operation, method, path)
            response_schema = (
                operation.get("responses", {})
                .get("200", {})
                .get("content", {})
                .get("application/json", {})
                .get("schema")
            )
            response_type = schemas.type_for(response_schema or {}, f"TMDB{op_name}ResponseDTO")

            request_schema = (
                (operation.get("requestBody") or {})
                .get("content", {})
                .get("application/json", {})
                .get("schema")
            )
            request_type = None
            if request_schema:
                request_type = schemas.type_for(request_schema, f"TMDB{op_name}RequestDTO")

            parameters = []
            for parameter in operation.get("parameters", []):
                raw_name = parameter["name"]
                parameters.append({
                    "raw": raw_name,
                    "name": camel(raw_name),
                    "type": swift_param_type(parameter),
                    "location": parameter.get("in"),
                    "required": bool(parameter.get("required")),
                })

            method_name = camel(op_name)
            endpoint_name = f"tmdb{op_name}"
            operations.append({
                "name": op_name,
                "method_name": method_name,
                "endpoint_name": endpoint_name,
                "http_method": method,
                "path": path_without_version(path),
                "response_type": response_type,
                "request_type": request_type,
                "parameters": parameters,
            })
    return operations


def endpoint_signature(operation, include_async=False):
    args = []
    for parameter in operation["parameters"]:
        swift_type = parameter["type"]
        if parameter["location"] == "query" and not parameter["required"]:
            args.append(f"{parameter['name']}: {swift_type}?")
        else:
            args.append(f"{parameter['name']}: {swift_type}")
    if operation["request_type"]:
        args.append(f"body: {operation['request_type']}")
    return ", ".join(args)


def call_arguments(operation):
    args = []
    for parameter in operation["parameters"]:
        args.append(f"{parameter['name']}: {parameter['name']}")
    if operation["request_type"]:
        args.append("body: body")
    return ", ".join(args)


def path_argument_value(parameter):
    if parameter["type"] == "String":
        return f"{parameter['name']}.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? {parameter['name']}"
    return f"String({parameter['name']})"


def generate_source(spec, operations, schemas):
    lines = [
        "//",
        "//  TMDBGeneratedAPI.swift",
        "//  MovieApp",
        "//",
        "//  Generated from TMDB OpenAPI v3. Do not edit by hand.",
        "//",
        "",
        "import Foundation",
        "",
        "enum TMDBJSONValue: Codable, Equatable {",
        "    case string(String)",
        "    case number(Double)",
        "    case bool(Bool)",
        "    case object([String: TMDBJSONValue])",
        "    case array([TMDBJSONValue])",
        "    case null",
        "",
        "    init(from decoder: Decoder) throws {",
        "        let container = try decoder.singleValueContainer()",
        "        if container.decodeNil() { self = .null }",
        "        else if let value = try? container.decode(Bool.self) { self = .bool(value) }",
        "        else if let value = try? container.decode(Double.self) { self = .number(value) }",
        "        else if let value = try? container.decode(String.self) { self = .string(value) }",
        "        else if let value = try? container.decode([TMDBJSONValue].self) { self = .array(value) }",
        "        else { self = .object(try container.decode([String: TMDBJSONValue].self)) }",
        "    }",
        "",
        "    func encode(to encoder: Encoder) throws {",
        "        var container = encoder.singleValueContainer()",
        "        switch self {",
        "        case .string(let value): try container.encode(value)",
        "        case .number(let value): try container.encode(value)",
        "        case .bool(let value): try container.encode(value)",
        "        case .object(let value): try container.encode(value)",
        "        case .array(let value): try container.encode(value)",
        "        case .null: try container.encodeNil()",
        "        }",
        "    }",
        "}",
        "",
    ]

    lines.extend(schemas.structs)
    lines.append("")
    lines.append("protocol TMDBGeneratedAPIProtocol {")
    for operation in operations:
        signature = endpoint_signature(operation)
        if signature:
            lines.append(f"    func {operation['method_name']}({signature}) async throws -> {operation['response_type']}")
        else:
            lines.append(f"    func {operation['method_name']}() async throws -> {operation['response_type']}")
    lines.append("}")
    lines.append("")
    lines.append("final class TMDBGeneratedAPI: TMDBGeneratedAPIProtocol {")
    lines.append("    private let networkClient: NetworkClientProtocol")
    lines.append("")
    lines.append("    init(networkClient: NetworkClientProtocol) {")
    lines.append("        self.networkClient = networkClient")
    lines.append("    }")
    lines.append("")
    for operation in operations:
        signature = endpoint_signature(operation)
        call_args = call_arguments(operation)
        throws_prefix = "try " if operation["request_type"] else ""
        if signature:
            lines.append(f"    func {operation['method_name']}({signature}) async throws -> {operation['response_type']} {{")
        else:
            lines.append(f"    func {operation['method_name']}() async throws -> {operation['response_type']} {{")
        if call_args:
            lines.append(f"        return try await networkClient.request({throws_prefix}Endpoint.{operation['endpoint_name']}({call_args}))")
        else:
            lines.append(f"        return try await networkClient.request(Endpoint.{operation['endpoint_name']}())")
        lines.append("    }")
        lines.append("")
    lines.append("}")
    lines.append("")
    lines.append("extension Endpoint {")
    for operation in operations:
        signature = endpoint_signature(operation)
        throws_suffix = " throws" if operation["request_type"] else ""
        path_parameters = [p for p in operation["parameters"] if p["location"] == "path"]
        if signature:
            lines.append(f"    static func {operation['endpoint_name']}({signature}){throws_suffix} -> Endpoint {{")
        else:
            lines.append(f"    static func {operation['endpoint_name']}(){throws_suffix} -> Endpoint {{")
        path_keyword = "var" if path_parameters else "let"
        lines.append(f"        {path_keyword} path = {string_literal(operation['path'])}")
        for parameter in path_parameters:
            lines.append(
                f"        path = path.replacingOccurrences(of: {string_literal('{' + parameter['raw'] + '}')}, with: {path_argument_value(parameter)})"
            )
        query_parameters = [p for p in operation["parameters"] if p["location"] == "query"]
        if query_parameters:
            lines.append("        let queryItems = tmdbQueryItems([")
            for parameter in query_parameters:
                lines.append(f"            ({string_literal(parameter['raw'])}, {parameter['name']}),")
            lines.append("        ])")
        else:
            lines.append("        let queryItems: [URLQueryItem] = []")
        body_expression = "nil"
        if operation["request_type"]:
            body_expression = "try JSONEncoder.tmdbGenerated.encode(body)"
        lines.append("        return Endpoint(")
        lines.append("            path: path,")
        lines.append(f"            method: .{operation['http_method']},")
        lines.append("            queryItems: queryItems,")
        lines.append(f"            body: {body_expression}")
        lines.append("        )")
        lines.append("    }")
        lines.append("")
    lines.append("}")
    lines.append("")
    lines.append("private extension Endpoint {")
    lines.append("    static func tmdbQueryItems(_ items: [(String, Any?)]) -> [URLQueryItem] {")
    lines.append("        items.compactMap { name, value in")
    lines.append("            guard let value else { return nil }")
    lines.append("            return URLQueryItem(name: name, value: String(describing: value))")
    lines.append("        }")
    lines.append("    }")
    lines.append("}")
    lines.append("")
    lines.append("private extension JSONEncoder {")
    lines.append("    static var tmdbGenerated: JSONEncoder {")
    lines.append("        let encoder = JSONEncoder()")
    lines.append("        return encoder")
    lines.append("    }")
    lines.append("}")
    lines.append("")
    return "\n".join(lines)


def sample_value(parameter):
    if parameter["type"] == "String":
        return '"value"'
    if parameter["type"] == "Int":
        return "1"
    if parameter["type"] == "Double":
        return "1.5"
    if parameter["type"] == "Bool":
        return "true"
    return ".null"


def sample_request_body(type_name):
    return f"{type_name}()"


def generate_tests(operations):
    lines = [
        "//",
        "//  TMDBGeneratedAPISuite.swift",
        "//  MovieAppTests",
        "//",
        "//  Generated from TMDB OpenAPI v3. Do not edit by hand.",
        "//",
        "",
        "import Foundation",
        "import Testing",
        "",
        "@testable import MovieApp",
        "",
        "@Suite(\"TMDBGeneratedAPI\")",
        "struct TMDBGeneratedAPISuite {",
    ]
    for operation in operations:
        args = []
        for parameter in operation["parameters"]:
            args.append(f"{parameter['name']}: {sample_value(parameter)}")
        if operation["request_type"]:
            args.append(f"body: {sample_request_body(operation['request_type'])}")
        call = ", ".join(args)
        call_expr = f"try Endpoint.{operation['endpoint_name']}({call})" if operation["request_type"] else f"Endpoint.{operation['endpoint_name']}({call})"
        if not call:
            call_expr = f"try Endpoint.{operation['endpoint_name']}()" if operation["request_type"] else f"Endpoint.{operation['endpoint_name']}()"

        lines.append(f"    @Test(\"{operation['name']} endpoint\")")
        lines.append(f"    func {operation['endpoint_name']}BuildsEndpoint() throws {{")
        lines.append(f"        let endpoint = {call_expr}")
        lines.append("")
        lines.append(f"        #expect(endpoint.path == {string_literal(operation['path'].replace('{', '').replace('}', '').replace('_id', 'Id') if False else expected_path(operation))})")
        lines.append(f"        #expect(endpoint.method == .{operation['http_method']})")
        if [p for p in operation["parameters"] if p["location"] == "query"]:
            lines.append("        #expect(endpoint.queryItems.isEmpty == false)")
        else:
            lines.append("        #expect(endpoint.queryItems.isEmpty == true)")
        if operation["request_type"]:
            lines.append("        #expect(endpoint.body != nil)")
        else:
            lines.append("        #expect(endpoint.body == nil)")
        lines.append("    }")
        lines.append("")
    lines.append("}")
    lines.append("")
    return "\n".join(lines)


def expected_path(operation):
    path = operation["path"]
    for parameter in operation["parameters"]:
        if parameter["location"] == "path":
            path = path.replace("{" + parameter["raw"] + "}", "1" if parameter["type"] != "String" else "value")
    return path


def main():
    spec = fetch_spec()
    schemas = SchemaGenerator()
    operations = make_operations(spec, schemas)

    SOURCE_OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    TEST_OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    SOURCE_OUTPUT.write_text(generate_source(spec, operations, schemas), encoding="utf-8")
    TEST_OUTPUT.write_text(generate_tests(operations), encoding="utf-8")

    print(f"Generated {len(operations)} TMDB operations")
    print(f"Wrote {SOURCE_OUTPUT}")
    print(f"Wrote {TEST_OUTPUT}")


if __name__ == "__main__":
    main()
