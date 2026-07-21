---
name: ios-staff-engineer
description: Implement, refactor, debug, review, and verify production-grade iOS code in MovieApp. Use for Swift, UIKit, SnapKit, concurrency, architecture, networking, persistence, navigation, testing, performance, security, accessibility, localization, or pull-request work where senior engineering judgment and repository-specific conventions are required.
---

# iOS Staff Engineer

Build the smallest robust solution that fits MovieApp's existing architecture. Preserve behavior and public contracts unless the task explicitly requires a change.

## Start with evidence

1. Read the root `AGENTS.md`, relevant production files, adjacent tests, and project settings.
2. Read [references/movieapp-engineering.md](references/movieapp-engineering.md). For reviews, risky changes, or cross-layer features, also read [references/engineering-quality-gates.md](references/engineering-quality-gates.md).
3. Trace the complete path affected by the change: UI, state, domain, data, dependencies, and tests.
4. Inspect `git status` before editing and preserve unrelated user changes.
5. Run `scripts/audit_movieapp.sh` for broad implementation/review tasks. Treat matches as leads, not automatic defects.
6. State assumptions only when they materially affect the implementation.

## Make engineering decisions

- Follow the existing UIKit + SnapKit + ViewModel + coordinator/router approach.
- Keep dependencies flowing through `AppDependencyContainer`; avoid service locators and new global mutable state.
- Put business rules in domain use cases, transport and persistence details in Data/Core, screen state in ViewModels, and rendering/event forwarding in ViewControllers.
- Prefer concrete, local code until an abstraction has at least two real consumers or creates a clear test seam.
- Keep UI work on `@MainActor`. Make cancellation and object lifetime explicit for asynchronous work.
- Treat actor reentrancy as a design constraint: revalidate state after suspension points before committing results.
- Make cross-isolation values `Sendable` by construction. Use actors or immutable value snapshots before considering `@unchecked Sendable`.
- Never add force unwraps, force casts, silent error swallowing, detached tasks, or stringly typed navigation without a documented necessity.
- Preserve localization, accessibility, privacy, logging discipline, and secure credential storage.
- Treat generated TMDB code as generated. Change its generator or source schema instead of hand-editing it.
- Avoid broad rewrites, speculative compatibility layers, and architecture migrations unrelated to the request.
- Design APIs for clarity at the call site: role-based names, grammatical labels, explicit side effects, and documented non-O(1) properties.

## Implement vertically

1. Define or update the domain model and contract when behavior changes.
2. Implement data access behind the contract.
3. Wire dependencies at the composition root.
4. Model every meaningful UI state explicitly, including loading, empty, content, recoverable error, and offline behavior when applicable.
5. Render state deterministically and keep ViewControllers free of business logic.
6. Add focused tests alongside each changed behavior.

For networking changes, prove a policy matrix: valid 2xx, malformed 2xx, relevant 4xx, bounded retryable 429/5xx, timeout/offline, and cancellation. Retry only idempotent or explicitly replayable requests. Never create an unbounded token-refresh or retry loop.

For persistence or credential changes, preserve existing data until the new path is verified. Handle every Keychain `OSStatus`, set an explicit accessibility policy, and use add-or-update rather than delete-then-add.

## Review like a staff engineer

Before finishing, inspect the diff for:

- actor-isolation violations, races, missing cancellation, and retain cycles;
- invalid state transitions and duplicate requests;
- leaky abstractions or dependency-direction violations;
- error messages exposed directly from low-level errors;
- accessibility, localization, Dynamic Type, and layout regressions;
- insecure storage, sensitive logs, or unsafe URL/request construction;
- unnecessary API surface and complexity;
- missing regression coverage.

Classify findings by user impact and evidence, not by stylistic preference. Fix material findings within scope instead of merely listing them.

## Verify

Run the narrowest useful tests first, then the repository suite when feasible. Swift Testing executes in parallel by default: keep fixtures isolated, use `#require` for prerequisite values, avoid sleeps, and serialize only unavoidable shared external state.

```bash
xcodebuild test \
  -project MovieApp.xcodeproj \
  -scheme MovieApp \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:MovieAppTests
```

If that simulator is unavailable, discover an available iPhone with `xcrun simctl list devices available` and use its UDID. For UI changes, also build and inspect the affected screen in Simulator. For performance, race, memory, or hang claims, collect evidence with the appropriate Xcode diagnostic, sanitizer, Memory Graph, or Instruments template; do not infer performance from code shape alone. Never claim a check passed unless it ran successfully; report the exact blocker and the checks that did run.

## Hand off

Summarize the user-visible outcome, important implementation decisions, verification performed, and any remaining risk. Keep the handoff compact.
