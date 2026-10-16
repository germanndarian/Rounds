# Rounds

A social drink tracker for nights out with friends — crews, live Nights, a shared
disposable-camera album and a morning "Wrapped" recap. Native iPhone app (Swift / SwiftUI),
backed by Supabase.

> Framed around memories and nights out, not volume: no "most drinks" leaderboards.

## Getting started

```sh
brew install xcodegen
xcodegen generate      # creates Rounds.xcodeproj (not committed)
open Rounds.xcodeproj
```

Requires Xcode 26+, iOS 18+.

## Structure

```
project.yml            XcodeGen spec (source of truth for the Xcode project)
Config/                xcconfig files; Secrets.xcconfig is gitignored
Rounds/App             App entry point, Supabase client
Rounds/Features        One folder per feature (Home, Crews, Nights, …)
RoundsTests            Swift Testing unit tests
supabase/              Supabase CLI config + SQL migrations
docs/                  Setup guides
```

## Backend

See [docs/SUPABASE_SETUP.md](docs/SUPABASE_SETUP.md).

## Workflow

`main` is protected: open a pull request, CI must pass, then merge.
