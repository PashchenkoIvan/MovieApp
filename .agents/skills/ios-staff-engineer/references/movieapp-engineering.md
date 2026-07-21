# MovieApp engineering reference

## Current project shape

- UI: programmatic UIKit with SnapKit.
- Presentation: `BaseViewController<ViewModel>` renders explicit `ViewState`; ViewModels expose state changes and receive UI events.
- Navigation: coordinator and routing protocols rooted in `AppCoordinator` and `AppRouting`.
- Composition: `AppDependencyContainer` creates concrete implementations.
- Domain: models, repository protocols, and use cases under `MovieApp/Domain`.
- Data/Core: TMDB API implementations, DTOs, networking, SwiftData, Keychain, configuration, and logging.
- Localization: per-feature string catalogs through `LocalizationService`.
- Tests: Swift Testing suites under `MovieAppTests`; UI tests under `MovieAppUITests`.
- Deployment target: iOS 26 for app targets at the time this skill was created. Re-check project settings before relying on it.

## Boundaries

Keep dependencies pointed inward:

```text
ViewController -> ViewModel -> UseCase -> Repository protocol
                                      <- Repository implementation -> API/storage
AppDependencyContainer wires concrete implementations.
Coordinator owns navigation transitions.
```

Do not let domain types import UIKit, SwiftData, or transport DTOs. Map external representations at the Data boundary.

## Concurrency and lifecycle

- Isolate UI-facing ViewModels to `@MainActor` when their state and callbacks are UI-bound.
- Retain tasks only when cancellation must follow screen or owner lifetime; cancel them explicitly.
- Use weak captures when an escaping closure is owned, directly or indirectly, by `self`.
- Check cancellation before publishing results.
- Avoid `Task.detached` unless actor inheritance is demonstrably wrong and sendability is proven.
- Do not mark types `@unchecked Sendable` to silence the compiler without a written invariant and tests.

## Testing expectations

- Add a regression test for every bug fix when deterministic reproduction is possible.
- Test ViewModel state transitions and routing effects independently.
- Test repository mapping, error translation, request construction, and persistence behavior at their boundaries.
- Prefer fakes/spies with narrow intent over general-purpose mocking frameworks.
- Keep tests deterministic: no live TMDB calls, timing guesses, shared storage, or order dependence.
- Add UI tests only for critical cross-layer journeys; do not replace cheap unit coverage with UI tests.

## Definition of done

- The requested behavior is complete, including failure and empty states.
- Architecture and dependency direction remain coherent.
- New user-facing text is localized.
- Interactive UI is accessible and works with Dynamic Type.
- Relevant tests pass and the app builds.
- The final diff contains no unrelated cleanup or generated-file edits.

## Swift API quality

- Optimize naming for the call site, not declaration brevity.
- Name values by semantic role rather than concrete type.
- Use verbs for mutating or effectful operations and noun/adjective phrases for pure results.
- Prefer clear labeled default parameters over families of nearly identical overloads.
- Document public behavior, thrown errors, and any computed property whose complexity is not O(1).

## Network policy

- Validate the HTTP response and status before decoding; transport success is not HTTP success.
- Inject the session/client and decoder so tests control transport deterministically.
- Translate transport, HTTP, decoding, authentication, and domain failures at the correct boundary.
- Retry only bounded transient failures with cancellation-aware backoff and server guidance such as `Retry-After`.
- Never retry non-idempotent requests unless the request is explicitly replayable.

## Evidence hierarchy

Prefer, in order: failing/passing tests; compiler and runtime diagnostics; reproducible simulator/device behavior; Instruments measurements; repository conventions; then general heuristics. A regex match or code smell is a triage lead, not proof of a defect.
