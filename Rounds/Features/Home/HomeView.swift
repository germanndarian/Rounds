import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var app

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                if app.hasCrews {
                    if app.isLive { liveBanner }
                    lastNight
                    crews
                } else {
                    emptyState
                }
            }
            .padding(.bottom, 110)
        }
        .scrollIndicators(.hidden)
        .background(Theme.bg.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            Button { app.startNight() } label: {
                Label(app.isLive ? "Back to the night" : "Start a Night",
                      systemImage: app.isLive ? "arrow.up.right" : "moon.stars.fill")
            }
            .buttonStyle(AccentPillStyle(height: 64, fontSize: 19))
            .background(.ultraThinMaterial, in: Capsule())
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Spacer()
                Button { app.tab = .profile } label: { Avatar(person: SampleData.me, size: 36) }
                    .accessibilityLabel("Profile")
            }
            .frame(height: 44)
            Text("Rounds").font(.heading(34)).tracking(-0.85)
            Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                .font(.body(15)).foregroundStyle(Theme.muted)
        }
        .padding(.horizontal, 20)
    }

    private var liveBanner: some View {
        Button { app.showingLive = true } label: {
            HStack(spacing: 12) {
                LiveDot(size: 10)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Live · \(app.crew.name)").font(.heading(16))
                    if let start = app.nightStart {
                        (Text("\(SampleData.currentBar) · ") + Text(start, style: .timer))
                            .font(.body(13)).foregroundStyle(Theme.muted).monospacedDigit()
                    }
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(Theme.muted)
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
            .background(RoundedRectangle(cornerRadius: 18).fill(Theme.accent.opacity(0.12)))
            .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.accent))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.top, 18)
    }

    private var lastNight: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Kicker("Last night")
                Spacer()
                Text("Thu, Oct 15").font(.body(13)).foregroundStyle(Theme.muted)
            }
            Button { app.showingRecap = true } label: {
                VStack(alignment: .leading, spacing: 0) {
                    FilmPhoto(caption: "photo · best of the night, Kasernen Club", stamp: "10 15 '26")
                        .frame(height: 290)
                        .overlay(alignment: .topLeading) { Tag(text: "Recap ready").padding(14) }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Café Tram 3 → Kasernen Club").font(.heading(20))
                        Text("4 bars · 37 photos · 6h 18m out").font(.body(14)).foregroundStyle(Theme.muted)
                        HStack {
                            AvatarStack(people: app.crew.members, size: 30)
                            Spacer()
                            Label("Watch recap", systemImage: "play.fill")
                                .font(.heading(15)).foregroundStyle(Theme.accent300)
                        }
                        .padding(.top, 2)
                    }
                    .padding(16)
                }
                .background(Theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusCard))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 26)
    }

    private var crews: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Kicker("Your crews")
                Spacer()
                Button("New") {}.font(.body(14)).foregroundStyle(Theme.accent300)
            }
            .padding(.horizontal, 20)
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(SampleData.crews) { crew in
                        Button { app.tab = .crew } label: { crewCard(crew) }.buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.top, 28)
    }

    private func crewCard(_ crew: Crew) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            AvatarStack(people: Array(crew.members.prefix(4)), size: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(crew.name).font(.heading(15)).lineLimit(1)
                Text("\(crew.memberCount) people · \(crew.nights) nights")
                    .font(.body(12)).foregroundStyle(Theme.muted)
            }
        }
        .padding(14)
        .frame(width: 156, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Theme.radiusTile).fill(Theme.surface))
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "wineglass")
                .font(.system(size: 36))
                .foregroundStyle(Theme.accent)
                .frame(width: 88, height: 88)
                .overlay(Circle().strokeBorder(Theme.divider))
                .padding(.bottom, 8)
            Text("No night yet").font(.heading(22))
            Text("Start a Night with your crew to begin.").font(.body(16)).foregroundStyle(Theme.muted)
            Button { app.tab = .crew } label: { Label("Create a crew", systemImage: "person.3") }
                .buttonStyle(OutlinePillStyle(height: 44, fontSize: 15, fill: false))
                .padding(.top, 10)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
        .padding(.top, 110)
    }
}

#Preview {
    HomeView()
        .environment(AppState())
        .preferredColorScheme(.dark)
}
