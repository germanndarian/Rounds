# Rounds roadmap

The project rules and conventions are in [../CLAUDE.md](../CLAUDE.md). Tick items off here as PRs merge.

## Done
- [x] Repo setup: XcodeGen project, CI (Build & test), protected `main`, Supabase CLI linked (#1)
- [x] UI prototype in SwiftUI on sample data, Nocturne design system (#2):
  onboarding with age gate, Home, Crew and invite sheet, Live Night and log sheet, disposable camera,
  Get home safe, morning recap, night map, Profile and badges

## Phase 1 – Backend foundation (needed for everything else)
- [ ] **Database schema and security rules:** profiles, crews, crew_members, invites, nights, drinks, photos, check_ins, with RLS on every table
- [ ] **Login:** Sign in with Apple through Supabase (`signInWithIdToken`), keeping the session, sign out, and the Apple Developer capability
- [ ] **Profile setup:** display name, avatar, storing the age confirmation
- [ ] **Data layer:** replace `SampleData` and the in-memory `AppState` with Supabase-backed models, plus loading and error states

## Phase 2 – The core loop (usable with friends)
- [ ] **Crews:** create, rename, leave; expiring invite links; join by QR code or universal link
- [ ] **Nights:** start, join, end; only one live Night per crew
- [ ] **Drink logging** saved to the database, with an offline queue for bad reception in bars
- [ ] **Live feed** over Supabase Realtime
- [ ] **Location:** detect the current bar (Core Location + MapKit place search), "Change" list of nearby bars
- [ ] **Home / Crew / Profile** computed from real data

## Phase 3 – Photos and the morning after
- [ ] **Disposable camera:** real capture (AVFoundation), upload to Storage, 27-shot limit
- [ ] **10:00 unlock**, enforced server-side
- [ ] **Photos on drinks:** PhotosPicker and the camera in the log sheet
- [ ] **Recap generation** when a Night ends: route, first and last round, album, badges
- [ ] **Night map** built from logged locations
- [ ] **Share to Stories:** render a frame as a 1080×1920 image and open Instagram Stories

## Phase 4 – Safety and social
- [ ] **Get home safe:** real check-ins, crew notifications, nudges, auto-reminders
- [ ] **Push notifications:** APNs plus a Supabase Edge Function (night started, nudge, recap ready)
- [ ] **BAC estimate:** opt-in weight and sex, Widmark-style range, kept on-device only
- [ ] **Rounds & IOUs:** who bought which round, saved and shared with the crew
- [ ] **Badges:** rules evaluated on the server, "earned" notification, progress for unearned badges

## Phase 5 – Apple platform extras
- [ ] **Widget extension** (App Group): small stats widget, medium "best photo" widget
- [ ] **Live Activity + Dynamic Island** (ActivityKit) with "Log a round" / "I'm home" actions
- [ ] **Siri / App Intents:** "Log a beer in Rounds"
- [ ] **Barcode scanner:** VisionKit plus a drinks database (e.g. Open Food Facts)
- [ ] **Soundtrack of the night:** MusicKit and/or Spotify
- [ ] **HealthKit:** sync to the Alcoholic Beverages type (opt-in)
- [ ] **Apple Watch app:** log a drink from the wrist
- [ ] **Yearly Wrapped**

## Phase 6 – Polish and release
- [ ] **Design gaps:** custom drink icons, app icon, launch screen, optional light mode, optional Inter font
- [ ] **Accessibility:** Dynamic Type, VoiceOver, reduced motion
- [ ] **Localization:** English and German
- [ ] **Settings:** account deletion (required by Apple), privacy controls, notification preferences
- [ ] **Privacy and legal:** privacy policy, terms, App Store privacy labels, permission prompt texts
- [ ] **App Store compliance check:** 18+ rating, no drink-count rankings anywhere
- [ ] **Quality:** crash reporting, analytics, unit and UI tests, TestFlight beta with the crew
- [ ] **Release:** screenshots, store listing, review submission
