---
name: build-and-test
description: Use when an xcodebuild build or test fails, the simulator dies or is missing, CI "Build & test" is red but local passes, or you need to pick the same iPhone simulator as CI, or check a screen with -startScreen. Not for plain build/test commands, those are in AGENTS.md.
---

# Build and test troubleshooting

Plain commands (generate, build, test, one test, `-startScreen`) are in AGENTS.md. This is what to do when they misbehave.

## Reading results
1. Run with the filter from AGENTS.md. Failures show as `error:` lines (compile) or `Test Case ... failed` plus `** TEST FAILED **`.
2. For a test failure, get the assertion: `xcodebuild test ... 2>&1 | grep -E "error:|Issue recorded|failed" | head -20`.
   Swift Testing prints `Issue recorded`, not XCTest-style lines.
3. Re-run only the failing test with `-only-testing:RoundsTests/AppStateTests/<test>` (test names are function names, no parentheses).

## Common failures
- `Mach error -308 (ipc/mig) server died` or the run ends with no test output: the simulator crashed, not your code.
  Re-run once. If it repeats: `xcrun simctl shutdown all`, then run again.
- `Unable to find a destination` / simulator name missing: `xcrun simctl list devices available | grep iPhone`,
  use a name from that list (`iPhone 17 Pro` exists here).
- Missing project or "no such scheme": run `xcodegen generate` (the `.xcodeproj` is gitignored).
- Missing Supabase URL/key at launch: copy `Config/Secrets.example.xcconfig` to `Config/Secrets.xcconfig` (never commit it).
- Stale build output: use `-derivedDataPath build` (gitignored) and delete `build/` only if it is clearly corrupt.

## Matching CI
CI (`.github/workflows`, runner `macos-26`) does not hardcode a device. It lists
`xcodebuild -showdestinations -scheme Rounds`, takes the first eligible iPhone simulator, and tests with `id=<that id>`.
Locally, reproduce with:
```sh
xcodebuild -showdestinations -scheme Rounds 2>/dev/null | sed '/Ineligible destinations/q' | grep 'platform:iOS Simulator' | grep 'name:iPhone' | head -1
```
Then pass `-destination "platform=iOS Simulator,id=<id>"`.

## Checking a screen
`-startScreen` only works in Debug builds. After `xcrun simctl launch`, take a look with
`xcrun simctl io booted screenshot /tmp/rounds.png` only when the change is visual.
Valid values: `onb home crew map profile live recap` (`live` fakes a night started 3.5h ago).

## Worked when
Filtered output ends in `** BUILD SUCCEEDED **` or `** TEST SUCCEEDED **` and no `error:` lines.
