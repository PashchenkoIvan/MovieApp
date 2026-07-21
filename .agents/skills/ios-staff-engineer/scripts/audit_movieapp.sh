#!/bin/sh
set -eu

project_root=${1:-.}
cd "$project_root"

printf '%s\n' '== Working tree =='
git status --short 2>/dev/null || true

printf '%s\n' '== Crash and unsafe boundaries (review contextually) =='
rg -n --glob '*.swift' --glob '!MovieAppTests/**' --glob '!MovieAppUITests/**' \
  'fatalError\(|preconditionFailure\(|assertionFailure\(|try!|as!|Task\.detached|@unchecked Sendable|nonisolated\(unsafe\)|withUnsafeContinuation|withUnsafeThrowingContinuation' MovieApp || true

printf '%s\n' '== Concurrency and task ownership =='
rg -n --glob '*.swift' 'Task\s*\{|Task\.detached|withCheckedContinuation|withCheckedThrowingContinuation|DispatchSemaphore|dispatch_group_wait' MovieApp || true

printf '%s\n' '== Error and logging boundaries =='
rg -n --glob '*.swift' 'localizedDescription|print\(|catch\s*\{' MovieApp || true

printf '%s\n' '== Sensitive storage and configuration =='
rg -n --glob '*.swift' --glob '*.plist' 'UserDefaults|SecItem|Keychain|api[_-]?key|access[_-]?token|refresh[_-]?token|password' MovieApp || true

printf '%s\n' '== UI quality leads =='
rg -n --glob '*.swift' 'systemFont\(ofSize:|leftAnchor|rightAnchor|\.left|\.right|UIView\.animate|Timer\.' MovieApp || true

printf '%s\n' 'Audit complete. Matches are evidence leads, not automatic defects.'
