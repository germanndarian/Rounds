import SwiftUI

struct CrewView: View {
    let crew: Crew
    @Environment(AppState.self) private var app
    @State private var showingInvite = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(crew.name).font(.heading(34)).tracking(-0.85)
                    Text("\(crew.memberCount) members · since \(crew.since)").font(.body(15)).foregroundStyle(Theme.neutral500)
                }
                .padding(.horizontal, 20)

                HStack(alignment: .top) {
                    ForEach(crew.members) { person in
                        VStack(spacing: 8) {
                            Avatar(person: person, size: 58)
                            Text(person.name).font(.body(13)).lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 22)

                HStack(spacing: 10) {
                    Button { showingInvite = true } label: { Label("Invite", systemImage: "person.badge.plus") }
                        .buttonStyle(OutlinePillStyle())
                    Button { app.startNight() } label: {
                        Label(app.isLive ? "Back to the night" : "Start a Night", systemImage: "moon.stars.fill")
                    }
                    .buttonStyle(AccentPillStyle(height: 52, fontSize: 16, glow: false))
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)

                HStack(spacing: 10) {
                    StatTile(value: "\(crew.nights)", label: "nights")
                    StatTile(value: "\(crew.bars)", label: "bars")
                    StatTile(value: "\(crew.photos)", label: "photos")
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)

                Text("Past nights").font(.heading(22)).padding(.horizontal, 20).padding(.top, 28).padding(.bottom, 4)
                VStack(spacing: 0) {
                    ForEach(SampleData.nights) { night in
                        Button { app.showingRecap = true } label: { nightRow(night) }.buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
        .background(Theme.bg.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Rename crew", systemImage: "pencil") {}
                    Button("Leave crew", systemImage: "rectangle.portrait.and.arrow.right", role: .destructive) {}
                } label: { Image(systemName: "ellipsis.circle") }
            }
        }
        .sheet(isPresented: $showingInvite) {
            InviteSheet(crew: crew)
        }
    }

    private func nightRow(_ night: NightSummary) -> some View {
        HStack(spacing: 14) {
            FilmPhoto(spacing: 8)
                .frame(width: 56, height: 56)
                .overlay(alignment: .bottomTrailing) {
                    Text(night.stamp).font(.mono(8)).foregroundStyle(Theme.accent300).padding(5)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 2) {
                Text(night.route).font(.heading(15)).lineLimit(2)
                Text("\(night.date) · \(night.meta)").font(.body(13)).foregroundStyle(Theme.neutral500)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.neutral600)
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) { FadingDivider() }
    }
}

#Preview {
    NavigationStack { CrewView(crew: SampleData.crews[0]) }
        .environment(AppState())
        .preferredColorScheme(.dark)
}
