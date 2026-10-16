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

In Debug builds you can jump straight to a screen with a launch argument
(Xcode → Edit Scheme → Run → Arguments): `-startScreen onb|home|crew|map|profile|live|recap`.
The gear menu on Profile also has prototype toggles (empty Home, replay onboarding).

## Structure

```
project.yml            XcodeGen spec (source of truth for the Xcode project)
Config/                xcconfig files; Secrets.xcconfig is gitignored
Rounds/App             App entry point, root/tab view, AppState, Supabase client
Rounds/DesignSystem    Nocturne tokens (Theme) and shared components
Rounds/Models          Models and prototype sample data
Rounds/Features        One folder per feature (Home, Crew, LiveNight, Recap, …)
RoundsTests            Swift Testing unit tests
supabase/              Supabase CLI config + SQL migrations
docs/                  Setup guides
```

## Backend

See [docs/SUPABASE_SETUP.md](docs/SUPABASE_SETUP.md).

## Workflow

`main` is protected: open a pull request, CI must pass, then merge.
