import SwiftUI

struct RootView: View {
    @AppStorage("onboarded") private var onboarded = false
    @State private var app = AppState()

    var body: some View {
        Group {
            if onboarded {
                MainTabView()
            } else {
                OnboardingView {
                    withAnimation(.easeInOut) { onboarded = true }
                    app.show(toast: "Signed in as \(SampleData.me.name)")
                }
            }
        }
        .toasts()
        .environment(app)
        .preferredColorScheme(.dark)
        .tint(Theme.accent)
        #if DEBUG
        .onAppear(perform: applyDebugStartScreen)
        #endif
    }

    #if DEBUG
    /// Jump to a screen when launched with `-startScreen <onb|home|crew|map|profile|live|recap>`.
    private func applyDebugStartScreen() {
        guard let screen = UserDefaults.standard.string(forKey: "startScreen") else { return }
        onboarded = screen != "onb"
        switch screen {
        case "crew": app.tab = .crew
        case "map": app.tab = .map
        case "profile": app.tab = .profile
        case "live":
            app.nightStart = .now.addingTimeInterval(-12_600)
            app.showingLive = true
        case "recap": app.showingRecap = true
        default: break
        }
    }
    #endif
}

struct MainTabView: View {
    @Environment(AppState.self) private var app

    var body: some View {
        @Bindable var app = app
        TabView(selection: $app.tab) {
            Tab("Home", systemImage: "house.fill", value: AppTab.home) { HomeView() }
            Tab("Crew", systemImage: "person.3.fill", value: AppTab.crew) {
                NavigationStack { CrewView(crew: app.crew) }
            }
            Tab("Map", systemImage: "map.fill", value: AppTab.map) { NightMapView() }
            Tab("Profile", systemImage: "person.crop.circle.fill", value: AppTab.profile) {
                NavigationStack { ProfileView() }
            }
        }
        .fullScreenCover(isPresented: $app.showingLive) {
            LiveNightView().toasts().environment(app)
        }
        .fullScreenCover(isPresented: $app.showingRecap) {
            RecapView().toasts().environment(app)
        }
    }
}
