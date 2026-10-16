import SwiftUI

struct LiveNightView: View {
    @Environment(AppState.self) private var app
    @Environment(\.dismiss) private var dismiss

    @State private var draft: LogDraft?
    @State private var showingCamera = false
    @State private var showingSafe = false
    @State private var logCount = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    topBar
                    hero
                    VStack(spacing: 10) {
                        ForEach(app.feed) { item in
                            FeedRow(item: item)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .animation(.spring(duration: 0.35, bounce: 0.2), value: app.feed.count)
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .bottom) { controlPanel }
            .nocturneHeroBackground()
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showingSafe) { HomeSafeView() }
        }
        .sheet(item: $draft) { draft in
            LogDrinkSheet(draft: draft)
        }
        .fullScreenCover(isPresented: $showingCamera) {
            DisposableCameraView().environment(app)
        }
        .sensoryFeedback(.success, trigger: logCount)
    }

    private var topBar: some View {
        HStack {
            CircleIconButton(systemImage: "chevron.down") { dismiss() }
                .accessibilityLabel("Minimize")
            Spacer()
            HStack(spacing: 8) {
                LiveDot()
                Text(app.crew.name).font(.body(14, weight: .medium))
            }
            Spacer()
            CircleIconButton(systemImage: "camera.fill") { showingCamera = true }
                .accessibilityLabel("Disposable camera")
        }
        .padding(.horizontal, 12)
        .padding(.top, 4)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let start = app.nightStart {
                Text(start, style: .timer)
                    .font(.heading(66)).tracking(-3)
                    .monospacedDigit()
                    .contentTransition(.numericText())
            }
            Label {
                Text("\(SampleData.currentBar), Langstrasse · since 10:54 PM")
            } icon: {
                Image(systemName: "mappin.circle.fill").foregroundStyle(Theme.accent)
            }
            .font(.body(15)).foregroundStyle(Theme.neutral400)
            .padding(.top, 10)
            HStack(spacing: 12) {
                AvatarStack(people: app.crew.members, size: 32, ring: Theme.bg, dimmed: [SampleData.mateo.id])
                Text("4 here · Mateo at Bar Limmatblick").font(.body(13)).foregroundStyle(Theme.neutral400)
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private var controlPanel: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Button { Task { await app.spinBuyer() } } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "shuffle").foregroundStyle(Theme.accent)
                        Text("Next round:")
                        Text(app.buyer.id == SampleData.me.id && !app.isSpinning ? "You" : app.buyer.name)
                            .fontWeight(.semibold)
                            .frame(minWidth: 52, alignment: .leading)
                            .contentTransition(.numericText())
                    }
                    .font(.body(15))
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .overlay(Capsule().strokeBorder(Theme.divider))
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: app.buyerIndex)

                Button { showingSafe = true } label: {
                    Label("Home safe", systemImage: "house")
                        .font(.body(15))
                        .padding(.horizontal, 16)
                        .frame(height: 46)
                        .overlay(Capsule().strokeBorder(Theme.divider))
                }
                .buttonStyle(.plain)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(DrinkKind.allCases) { kind in
                    Button { log(kind) } label: {
                        VStack(spacing: 4) {
                            Image(systemName: kind.symbol).font(.system(size: 22)).foregroundStyle(Theme.accent300)
                            Text(kind.label).font(.body(13, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 62)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Theme.text.opacity(0.06)))
                        .overlay {
                            if kind == .custom {
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(Theme.neutral700, style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                            }
                        }
                    }
                    .buttonStyle(QuickLogStyle())
                }
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 32).fill(.ultraThinMaterial))
        .overlay(RoundedRectangle(cornerRadius: 32).strokeBorder(Theme.neutral700.opacity(0.6)))
        .padding(.horizontal, 10)
        .padding(.bottom, 4)
        .padding(.top, 40)
        .background(
            LinearGradient(stops: [.init(color: Theme.bg.opacity(0), location: 0), .init(color: Theme.bg, location: 0.4)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }

    private func log(_ kind: DrinkKind) {
        let id = withAnimation { app.log(kind) }
        logCount += 1
        draft = LogDraft(id: id, kind: kind, time: .now)
    }
}

private struct QuickLogStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Theme.text)
            .background(RoundedRectangle(cornerRadius: 20).fill(Theme.accent.opacity(configuration.isPressed ? 0.24 : 0)))
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct FeedRow: View {
    let item: FeedItem

    var body: some View {
        switch item.kind {
        case .system(let symbol, let text):
            Label("\(text) · \(item.time.formatted(date: .omitted, time: .shortened))", systemImage: symbol)
                .font(.mono(12))
                .foregroundStyle(Theme.neutral500)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 4)
                .padding(.vertical, 6)
        case .drink, .photo:
            post
        }
    }

    private var post: some View {
        HStack(alignment: .top, spacing: 12) {
            if let person = item.person { Avatar(person: person, size: 36) }
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top, spacing: 8) {
                    (Text(item.person?.name ?? "").fontWeight(.semibold) + Text(" \(item.verb)"))
                        .font(.body(15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: item.symbol).font(.system(size: 18)).foregroundStyle(Theme.accent)
                }
                Text("\(item.bar) · \(item.time.formatted(date: .omitted, time: .shortened))")
                    .font(.body(12)).foregroundStyle(Theme.neutral500)
                if let comment = item.comment {
                    Text(comment).font(.body(15)).foregroundStyle(Theme.neutral200).padding(.top, 2)
                }
                if case .photo = item.kind {
                    SealedPhoto().frame(height: 130).clipShape(RoundedRectangle(cornerRadius: 12)).padding(.top, 6)
                } else if item.hasPhoto {
                    FilmPhoto(caption: "photo · drink").frame(height: 150).clipShape(RoundedRectangle(cornerRadius: 12)).padding(.top, 6)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 18).fill(Theme.surface))
    }
}

#Preview {
    let app = AppState()
    app.nightStart = .now.addingTimeInterval(-12_600)
    return LiveNightView()
        .environment(app)
        .preferredColorScheme(.dark)
}
