//
//  Log.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import Foundation

// MARK: - Routing Type

/// Shows how a screen was opened.
enum RoutingType: String {
    case present
    case push
    case set
}

// MARK: - Screens

/// All app screens used by logger and localization.
enum Screens: String {
    case main = "Main"
    case login = "Login"
    case root = "Root"

    /// String catalog table for each screen.
    var localizationTable: String? {
        switch self {
        case .login:
            return "LoginLocalizable"
        case .main:
            return "MainLocalizable"
        case .root:
            return nil
        }
    }
}

// MARK: - Log Level

/// Shows how important a log message is.
enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

// MARK: - Log Category

/// Groups log messages by app area.
enum LogCategory: String {
    case app = "APP"
    case lifecycle = "LIFECYCLE"
    case routing = "ROUTING"
    case network = "NETWORK"
    case state = "STATE"
    case localization = "LOCALIZATION"
}

// MARK: - Log Service

/// Universal logger for the app.
///
/// It prints logs as one readable table with fixed columns.
final class LogService {
    private enum ColumnWidth {
        static let time = 23
        static let level = 7
        static let category = 12
        static let screen = 10
        static let message = 28
        static let metadata = 56
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private static var didPrintHeader = false

    private let screen: Screens?
    private let isEnabled: Bool

    // MARK: - Init

    init(screen: Screens? = nil, isEnabled: Bool = true) {
        self.screen = screen
        self.isEnabled = isEnabled
    }

    // MARK: - Public Methods

    /// Prints a general log message.
    func log(
        _ message: String,
        level: LogLevel = .debug,
        category: LogCategory = .app,
        metadata: [String: String] = [:],
        file: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        guard isEnabled else { return }

        Self.printHeaderIfNeeded()

        let time = Self.dateFormatter.string(from: Date())
        let screenValue = screen?.rawValue ?? "Global"
        let metadataValue = formatMetadata(metadata)
        let sourceValue = formatSource(file: file, function: function, line: line)

        print(
            formatTableRow(
                time: time,
                level: level.rawValue,
                category: category.rawValue,
                screen: screenValue,
                message: message,
                metadata: metadataValue,
                source: sourceValue
            )
        )
    }

    /// Prints a lifecycle message for a screen.
    func lifecycle(
        _ event: String,
        file: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        log(
            event,
            level: .debug,
            category: .lifecycle,
            file: file,
            function: function,
            line: line
        )
    }

    /// Prints a state change message.
    func state(
        _ message: String,
        metadata: [String: String] = [:],
        file: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        log(
            message,
            level: .debug,
            category: .state,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }

    /// Prints a network message.
    func network(
        _ message: String,
        level: LogLevel = .debug,
        metadata: [String: String] = [:],
        file: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        log(
            message,
            level: level,
            category: .network,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }

    /// Prints a navigation message between screens.
    func routing(
        from: Screens,
        to: Screens,
        type: RoutingType = .push,
        animated: Bool,
        file: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        log(
            "Route",
            level: .info,
            category: .routing,
            metadata: [
                "from": from.rawValue,
                "to": to.rawValue,
                "type": type.rawValue,
                "animated": String(animated)
            ],
            file: file,
            function: function,
            line: line
        )
    }
}

// MARK: - Backward Compatibility

extension LogService {
    /// Old lifecycle logging method. Prefer `lifecycle(_:)` in new code.
    func screenLog(_ message: String) {
        lifecycle(message)
    }

    /// Old routing logging method. Prefer `routing(from:to:type:animated:)` in new code.
    func routingLog(from: Screens, to: Screens, type: RoutingType = .push) {
        routing(from: from, to: to, type: type, animated: true)
    }
}

// MARK: - Private Helpers

private extension LogService {
    static func printHeaderIfNeeded() {
        guard !didPrintHeader else { return }
        didPrintHeader = true

        let header = [
            "TIME".padded(to: ColumnWidth.time),
            "LEVEL".padded(to: ColumnWidth.level),
            "CATEGORY".padded(to: ColumnWidth.category),
            "SCREEN".padded(to: ColumnWidth.screen),
            "MESSAGE".padded(to: ColumnWidth.message),
            "METADATA".padded(to: ColumnWidth.metadata),
            "SOURCE"
        ].joined(separator: " | ")

        let separator = [
            String(repeating: "-", count: ColumnWidth.time),
            String(repeating: "-", count: ColumnWidth.level),
            String(repeating: "-", count: ColumnWidth.category),
            String(repeating: "-", count: ColumnWidth.screen),
            String(repeating: "-", count: ColumnWidth.message),
            String(repeating: "-", count: ColumnWidth.metadata),
            String(repeating: "-", count: 40)
        ].joined(separator: "-+-")

        print(header)
        print(separator)
    }

    func formatTableRow(
        time: String,
        level: String,
        category: String,
        screen: String,
        message: String,
        metadata: String,
        source: String
    ) -> String {
        [
            time.padded(to: ColumnWidth.time),
            level.padded(to: ColumnWidth.level),
            category.padded(to: ColumnWidth.category),
            screen.padded(to: ColumnWidth.screen),
            message.padded(to: ColumnWidth.message),
            metadata.padded(to: ColumnWidth.metadata),
            source
        ].joined(separator: " | ")
    }

    func formatMetadata(_ metadata: [String: String]) -> String {
        guard !metadata.isEmpty else { return "-" }

        return metadata
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: ", ")
    }

    func formatSource(file: StaticString, function: StaticString, line: UInt) -> String {
        let fileName = String(describing: file)
            .split(separator: "/")
            .last
            .map(String.init) ?? String(describing: file)

        return "\(fileName):\(line) \(function)"
    }
}

// MARK: - String Helpers

private extension String {
    func padded(to length: Int) -> String {
        let cleanValue = replacingOccurrences(of: "\n", with: " ")

        guard cleanValue.count <= length else {
            let prefixLength = max(length - 1, 0)
            return String(cleanValue.prefix(prefixLength)) + "…"
        }

        return cleanValue + String(repeating: " ", count: length - cleanValue.count)
    }
}
