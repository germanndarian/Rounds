import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var app
    @AppStorage("onboarded") private var onboarded = true
    @State private var openBadge: Badge?

    private let stats: [(symbol: String, value: String, label: String, size: CGFloat)] = [
        ("moon.stars.fill", "48", "Nights out", 34),
        ("storefront.fill", "61", "Bars visited", 34),
        ("globe.europe.africa.fill", "4", "Countries", 34),
        ("film.stack", "1,284", "Photos developed", 34),
        (DrinkKind.cocktail.symbol, "Negroni", "Favourite drink", 22),
        ("mappin.and.ellipse", "Hinterhof 8", "Most visited · 12 nights", 22),
    ]

    var body: some View {
        @Bindable var app = app
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 16) {
                    Avatar(person: SampleData.me, size: 72)
                        .overlay(Circle().strokeBorder(Theme.accent).padding(-4))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(SampleData.me.name).font(.heading(30)).tracking(-0.6)
                        Text("Zürich · since March 2025").font(.body(14)).foregroundStyle(Theme.neutral500)
                    }
                }
                .padding(.horizontal, 20)

                streak

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(stats, id: \.label) { stat in
                        VStack(alignment: .leading, spacing: 6) {
                            Image(systemName: stat.symbol).font(.system(size: 18)).foregroundStyle(Theme.accent300)
                            Text(stat.value).font(.heading(stat.size)).tracking(-0.03 * stat.size)
                                .lineLimit(1).minimumScaleFactor(0.7).padding(.top, 6)
                            Text(stat.label).font(.body(13)).foregroundStyle(Theme.neutral500)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: Theme.radiusTile).fill(Theme.surface))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

                HStack(alignment: .firstTextBaseline) {
                    Text("Badges").font(.heading(22))
                    Spacer()
                    Text("\(SampleData.badges.filter(\.earned).count) of \(SampleData.badges.count)")
                        .font(.body(14)).foregroundStyle(Theme.neutral500)
                }
                .padding(.horizontal, 20).padding(.top, 28).padding(.bottom, 14)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 18) {
                    ForEach(SampleData.badges) { badge in
                        Button { openBadge = badge } label: {
                            VStack(spacing: 8) {
                                BadgeMedal(badge: badge)
                                Text(badge.name).font(.body(13, weight: .medium)).multilineTextAlignment(.center)
                                Text(badge.earned ? badge.code : badge.detail).font(.mono(10)).foregroundStyle(Theme.neutral500)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
        .background(Theme.bg.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Section("Prototype") {
                        Toggle("New user (empty Home)", isOn: Binding(get: { !app.hasCrews }, set: { app.hasCrews = !$0 }))
                        Button("Replay onboarding", systemImage: "arrow.counterclockwise") { onboarded = false }
                    }
                } label: { Image(systemName: "gearshape") }
            }
        }
        .sheet(item: $openBadge) { BadgeSheet(badge: $0) }
    }

    private var streak: some View {
        HStack(spacing: 14) {
            Image(systemName: "flame.fill").font(.system(size: 28)).foregroundStyle(Theme.accent)
            VStack(alignment: .leading, spacing: 2) {
                Text("5 Fridays in a row").font(.heading(18))
                Text("Longest streak: 7 weeks").font(.body(13)).foregroundStyle(Theme.neutral400)
            }
            Spacer()
            HStack(spacing: 4) {
                ForEach([false, false, false, true, true, true, true, true].indices, id: \.self) { index in
                    Circle().fill(index >= 3 ? Theme.accent : Theme.neutral800).frame(width: 8, height: 8)
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20).fill(Theme.accent.opacity(0.08)))
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Theme.accent))
        .padding(.horizontal, 16)
        .padding(.top, 22)
    }
}

struct BadgeSheet: View {
    let badge: Badge
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 14) {
            BadgeMedal(badge: badge, size: 140)
                .shadow(color: Theme.accent.opacity(badge.earned ? 0.35 : 0), radius: 25)
                .padding(.top, 28)
            Text(badge.code).font(.mono(11)).tracking(0.9).foregroundStyle(Theme.neutral500).padding(.top, 6)
            Text(badge.name).font(.heading(28)).tracking(-0.56)
            Text(badge.description).font(.body(16)).foregroundStyle(Theme.neutral400)
                .multilineTextAlignment(.center).frame(maxWidth: 280)
            Text(badge.detail).font(.body(14)).foregroundStyle(Theme.accent300)
            Button("Close") { dismiss() }
                .buttonStyle(OutlinePillStyle(height: 54))
                .padding(.top, 8)
        }
        .padding(.horizontal, 24)
        .presentationDetents([.height(470)])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.surface)
    }
}

#Preview {
    NavigationStack { ProfileView() }
        .environment(AppState())
        .preferredColorScheme(.dark)
}
