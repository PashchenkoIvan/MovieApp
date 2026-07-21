# Engineering quality gates

Use the sections relevant to the change. Do not inflate a small patch into a full audit.

## Architecture gate

- Inventory the state owner, inputs, outputs, dependencies, side effects, navigation handoff, and tests.
- Choose the smallest boundary that solves the observed pressure.
- Keep Coordinator focused on navigation and lifecycle ownership.
- Migrate one tested vertical slice at a time; do not rewrite UI, networking, and persistence simultaneously.
- Reject forwarding-only abstractions and protocols without a real substitution or dependency boundary.

## Concurrency gate

- Protect mutable shared state with actor isolation or a proven synchronization boundary.
- Keep UIKit and presentation state on `@MainActor`.
- Prefer structured concurrency: `async let` for a fixed fan-out and task groups for dynamic fan-out.
- Store a `Task` only when its lifetime or cancellation must be owned.
- Check cancellation in loops and before publishing results.
- Revalidate invariants after every suspension point that separates a read from a write.
- Avoid blocking async work with semaphores or dispatch-group waits.
- Treat `Task.detached`, unsafe continuations, `nonisolated(unsafe)`, and `@unchecked Sendable` as audit boundaries requiring a written invariant.

## Testing gate

- Test observable behavior and state transitions rather than implementation calls.
- Cover success, boundary values, failures, cancellation, and duplicate/reentrant events where relevant.
- Use `#require` when later assertions depend on an optional or condition; use `#expect` for independent evidence.
- Replace sleeps with injected clocks, confirmations, or deterministic synchronization.
- Keep each test independent because Swift Testing runs in parallel by default.
- Keep XCUITest for a small number of critical cross-layer journeys and XCTest where required for UI/performance/snapshot tooling.

## Security and privacy gate

- Keep tokens and credentials in Keychain, never preferences, plist, source, files, or logs.
- Handle Keychain success, duplicate, missing, locked-device, and unexpected `OSStatus` values.
- Set the accessibility policy explicitly and avoid delete-then-add updates.
- Redact sensitive logging metadata and review third-party SDK data collection.
- Ask for system permissions only in context, after user intent, with localized purpose strings and a denial recovery path.
- Do not invent certificate pinning or cryptography; document key ownership, storage, rotation, recovery, and availability.

## Reliability gate

- Audit force unwraps, casts, indexing, fatal paths, continuation resumption, empty catches, and invalid state transitions contextually.
- Treat `fatalError` in impossible programmer-error initializers differently from reachable user/data paths.
- Map low-level failures to localized, actionable UI states without leaking raw server or `localizedDescription` text.
- Preserve partial content when a transient failure does not require replacing the entire screen.

## Performance gate

- Define the concrete symptom and reproduction before optimizing.
- Measure CPU with Time Profiler, memory growth with Allocations/Leaks and Memory Graph, hitches with Animation Hitches/Core Animation, I/O with File Activity, and energy with Power Profiler.
- Use Thread Performance Checker for priority inversions and main-thread non-UI work; use ASan/TSan/Main Thread Checker for runtime safety as appropriate.
- Move synchronous I/O, large decoding, and image processing off the main actor while keeping UI publication isolated.
- Check collection cell reuse, image downsampling/cancellation, layout invalidation, cache bounds, and screen deallocation for UIKit-heavy flows.

## Review output

For each actionable finding, provide severity, exact evidence, user or system impact, and the smallest safe correction. Omit speculative findings that cannot be tied to a reachable path or violated invariant.

## Research basis

This synthesis was informed by the curated Swift Agent Skills directory, `dpearson2699/swift-ios-skills`, `twostraws/swiftui-agent-skill`, and `mwd1234/ios-agentic-skills`, then narrowed to MovieApp's UIKit architecture and checked against Apple documentation. Re-verify version-specific Swift/Xcode claims before applying them.
