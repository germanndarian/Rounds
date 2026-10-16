import MapKit
import SwiftUI

/// Story-style morning recap. Tap right to advance, left to go back, hold to pause; frames auto-advance after 6s.
struct RecapView: View {
    @Environment(AppState.self) private var app
    @Environment(\.dismiss) private var dismiss

    @State private var frame = 0
    @State private var progress = 0.0
    @State private var paused = false

    private let frameCount = 6
    private let frameDuration = 6.0

    var body: some View {
        ZStack(alignment: .top) {
            background.ignoresSafeArea()

            Group {
                switch frame {
                case 0: intro
                case 1: route
                case 2: album
                case 3: firstAndLast
                case 4: soundtrack
                default: badges
                }
            }
            .id(frame)
            .transition(.opacity)
            .padding(.horizontal, 24)
            .padding(.top, 90)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            tapZones
            header
        }
        .safeAreaInset(edge: .bottom) { footer }
        .foregroundStyle(Theme.text)
        .animation(.easeInOut(duration: 0.4), value: frame)
        .task(id: frame) { await runTimer() }
    }

    // MARK: Chrome

    private var background: some View {
        ZStack {
            Theme.bg
            if frame == 0 {
                Theme.section
                RadialGradient(colors: [Theme.sectionGlow, .clear], center: UnitPoint(x: 0.8, y: 0.1), startRadius: 0, endRadius: 420)
            } else if frame == frameCount - 1 {
                RadialGradient(colors: [Theme.accent900, .clear], center: UnitPoint(x: 0.5, y: 0.3), startRadius: 0, endRadius: 380)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: frame)
    }

    private var header: some View {
        VStack(spacing: 12) {
            HStack(spacing: 4) {
                ForEach(0..<frameCount, id: \.self) { index in
                    GeometryReader { geo in
                        Capsule().fill(Theme.text.opacity(0.25))
                            .overlay(alignment: .leading) {
                                Capsule().fill(Theme.text)
                                    .frame(width: geo.size.width * (index < frame ? 1 : index > frame ? 0 : progress))
                            }
                    }
                    .frame(height: 3)
                }
            }
            HStack {
                HStack(spacing: 8) {
                    Text("R").font(.heading(12)).foregroundStyle(Theme.accent200)
                        .frame(width: 24, height: 24)
                        .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(Theme.accent))
                    Text("Rounds Recap · Thu, Oct 15").font(.body(13))
                }
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark").font(.system(size: 18, weight: .medium)).frame(width: 44, height: 44)
                }
                .accessibilityLabel("Close recap")
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
    }

    private var tapZones: some View {
        HStack(spacing: 0) {
            Color.clear.contentShape(Rectangle())
                .containerRelativeFrame(.horizontal) { width, _ in width * 0.32 }
                .onTapGesture { go(to: frame - 1) }
            Color.clear.contentShape(Rectangle())
                .onTapGesture { go(to: frame + 1) }
        }
        .padding(.vertical, 110)
        .onLongPressGesture(minimumDuration: 0.2, perform: {}, onPressingChanged: { paused = $0 })
        .accessibilityHidden(true)
    }

    private var footer: some View {
        HStack(spacing: 10) {
            // TODO: render the frame with ImageRenderer at 1080×1920 and hand it to Instagram Stories.
            Button { app.show(toast: "Frame ready for Instagram Stories") } label: {
                Label("Share to Stories", systemImage: "square.and.arrow.up")
                    .font(.heading(16))
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(.ultraThinMaterial, in: Capsule())
                    .overlay(Capsule().strokeBorder(Theme.text.opacity(0.3)))
            }
            .buttonStyle(.plain)
            if frame == frameCount - 1 {
                Button("Done") { dismiss() }
                    .buttonStyle(AccentPillStyle(height: 54, fontSize: 16, fill: false, glow: false))
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }

    private func go(to index: Int) {
        guard (0..<frameCount).contains(index) else { return }
        frame = index
    }

    private func runTimer() async {
        progress = 0
        while progress < 1 {
            try? await Task.sleep(for: .milliseconds(100))
            if Task.isCancelled { return }
            if !paused { progress = min(1, progress + 0.1 / frameDuration) }
        }
        if frame < frameCount - 1 { frame += 1 }
    }

    // MARK: Frames

    private var intro: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()
            Text("THURSDAY, OCTOBER 15").font(.body(12)).tracking(1.4).foregroundStyle(Theme.accent200)
            Text("Last night with \(app.crew.name)").font(.heading(54)).tracking(-2.4).lineSpacing(-4)
            AvatarStack(people: app.crew.members, size: 52, ring: Theme.section)
            Text("8:06 PM – 2:24 AM · 4 BARS · 5 FRIENDS").font(.mono(13)).foregroundStyle(Theme.neutral300)
            Spacer()
        }
    }

    private var route: some View {
        let distance = Measurement(value: 3.9, unit: UnitLength.kilometers)
            .formatted(.measurement(width: .wide, usage: .road))
        return VStack(alignment: .leading, spacing: 18) {
            Text("4 bars,\n\(distance) on foot").font(.heading(40)).tracking(-1.6)
            RouteMap(selected: nil, interactive: false)
                .frame(height: 270)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusCard))
            VStack(alignment: .leading, spacing: 8) {
                ForEach(SampleData.stops) { stop in
                    HStack(spacing: 12) {
                        Text(stop.arrived).font(.mono(13)).foregroundStyle(Theme.neutral500).frame(width: 70, alignment: .leading)
                        Text(stop.name).font(.body(15))
                    }
                }
            }
        }
    }

    private var album: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("37 photos developed at 10:00").font(.heading(40)).tracking(-1.6)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                ForEach(Array([-2, 1.5, -1, 2, -1.5, 1, -0.5, 2, -2].enumerated()), id: \.offset) { _, rotation in
                    Polaroid(padding: 4, bottom: 14, rotation: rotation) {
                        FilmPhoto(spacing: 8).aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            Text("Amara shot the most: 11 frames").font(.body(14)).foregroundStyle(Theme.neutral400)
        }
    }

    private var firstAndLast: some View {
        VStack(alignment: .leading, spacing: 34) {
            moment(kicker: "First round", time: "8:24", period: "PM", text: "Aperol Spritz at Café Tram 3, bought by Priya")
            FadingDivider()
            moment(kicker: "Last round", time: "1:52", period: "AM", text: "A glass of water at Kasernen Club. Good call, Lukas.")
        }
        .padding(.top, 20)
    }

    private func moment(kicker: String, time: String, period: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Kicker(kicker)
            (Text(time).font(.heading(76)).tracking(-3.8) + Text(" \(period)").font(.heading(28)))
                .monospacedDigit()
            Text(text).font(.body(17)).foregroundStyle(Theme.neutral300)
        }
    }

    private var soundtrack: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("The soundtrack of the night").font(.heading(40)).tracking(-1.6)
            VStack(spacing: 0) {
                ForEach(SampleData.songs) { song in
                    HStack(spacing: 14) {
                        Text("\(song.rank)").font(.heading(22)).foregroundStyle(Theme.accent300).frame(width: 22)
                        FilmPhoto(spacing: 7).frame(width: 44, height: 44).clipShape(RoundedRectangle(cornerRadius: 8))
                        VStack(alignment: .leading, spacing: 1) {
                            Text(song.title).font(.body(16))
                            Text("\(song.artist) · \(song.bar)").font(.body(13)).foregroundStyle(Theme.neutral500)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .overlay(alignment: .bottom) { FadingDivider() }
                }
            }
        }
    }

    private var badges: some View {
        let earned = [SampleData.badges[0], SampleData.badges[2], SampleData.badges[4]]
        return VStack(alignment: .leading, spacing: 28) {
            Text("\(earned.count) badges earned").font(.heading(40)).tracking(-1.6)
            VStack(alignment: .leading, spacing: 14) {
                ForEach(earned) { badge in
                    HStack(spacing: 16) {
                        BadgeMedal(badge: badge, size: 72)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(badge.name).font(.heading(19))
                            Text(badge.description).font(.body(14)).foregroundStyle(Theme.neutral400)
                        }
                    }
                }
            }
        }
        .padding(.top, 20)
    }
}

#Preview {
    RecapView()
        .environment(AppState())
        .preferredColorScheme(.dark)
}
