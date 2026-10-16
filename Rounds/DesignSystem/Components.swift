import SwiftUI

// MARK: - Buttons

/// Primary action: accent outline, tinted fill and soft glow.
struct AccentPillStyle: ButtonStyle {
    var height: CGFloat = 56
    var fontSize: CGFloat = 17
    var fill = true
    var glow = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.heading(fontSize))
            .foregroundStyle(Theme.accent200)
            .padding(.horizontal, 22)
            .frame(maxWidth: fill ? .infinity : nil)
            .frame(height: height)
            .background(Capsule().fill(Theme.accent.opacity(configuration.isPressed ? 0.28 : 0.14)))
            .overlay(Capsule().strokeBorder(Theme.accent, lineWidth: 1))
            .shadow(color: Theme.accent.opacity(glow ? 0.3 : 0), radius: 14)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

/// Secondary action: hairline outline.
struct OutlinePillStyle: ButtonStyle {
    var height: CGFloat = 52
    var fontSize: CGFloat = 16
    var fill = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.heading(fontSize))
            .foregroundStyle(Theme.text)
            .padding(.horizontal, 16)
            .frame(maxWidth: fill ? .infinity : nil)
            .frame(height: height)
            .background(Capsule().fill(Theme.text.opacity(configuration.isPressed ? 0.1 : 0)))
            .overlay(Capsule().strokeBorder(Theme.divider, lineWidth: 1))
    }
}

/// Round translucent icon button used in top bars.
struct CircleIconButton: View {
    let systemImage: String
    var size: CGFloat = 44
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Theme.text)
                .frame(width: size, height: size)
                .background(Circle().fill(Theme.text.opacity(0.08)))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Avatars

struct Avatar: View {
    let person: Person
    var size: CGFloat = 36
    var ring: Color? = nil
    var dimmed = false

    var body: some View {
        Text(person.initial)
            .font(.system(size: size * 0.4, weight: .semibold))
            .foregroundStyle(Theme.neutral100)
            .frame(width: size, height: size)
            .background(Circle().fill(person.color))
            .overlay {
                if let ring { Circle().strokeBorder(ring, lineWidth: max(2, size / 16)).padding(-max(2, size / 16)) }
            }
            .opacity(dimmed ? 0.4 : 1)
            .accessibilityLabel(person.name)
    }
}

struct AvatarStack: View {
    let people: [Person]
    var size: CGFloat = 30
    var ring: Color = Theme.surface
    var dimmed: Set<String> = []

    var body: some View {
        HStack(spacing: -size * 0.27) {
            ForEach(people) { person in
                Avatar(person: person, size: size, ring: ring, dimmed: dimmed.contains(person.id))
            }
        }
    }
}

// MARK: - Text & labels

/// Small uppercase section label.
struct Kicker: View {
    let text: String
    var color: Color = Theme.accent300

    init(_ text: String, color: Color = Theme.accent300) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 11, weight: .medium))
            .tracking(1.1)
            .foregroundStyle(color)
    }
}

struct Tag: View {
    enum Style { case accent, neutral }
    let text: String
    var systemImage: String? = nil
    var style: Style = .accent

    var body: some View {
        HStack(spacing: 4) {
            if let systemImage { Image(systemName: systemImage) }
            Text(text)
        }
        .font(.system(size: 11, weight: .medium))
        .foregroundStyle(style == .accent ? Theme.accent100 : Theme.neutral100)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(RoundedRectangle(cornerRadius: 6).fill(style == .accent ? Theme.accent800 : Theme.neutral800))
    }
}

/// Nocturne signature: rules fade to transparent at both ends.
struct FadingDivider: View {
    var body: some View {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0),
                .init(color: Theme.divider, location: 0.12),
                .init(color: Theme.divider, location: 0.88),
                .init(color: .clear, location: 1),
            ],
            startPoint: .leading, endPoint: .trailing
        )
        .frame(height: 1)
    }
}

struct LiveDot: View {
    var size: CGFloat = 8
    @State private var dim = false

    var body: some View {
        Circle()
            .fill(Theme.accent)
            .frame(width: size, height: size)
            .shadow(color: Theme.accent, radius: 5)
            .opacity(dim ? 0.3 : 1)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) { dim = true }
            }
    }
}

// MARK: - Photos

/// Placeholder for a film photo until real images exist: diagonal grain on near-black.
struct FilmPhoto: View {
    var caption: String? = nil
    var stamp: String? = nil
    var spacing: CGFloat = 10

    var body: some View {
        Canvas { context, size in
            var path = Path()
            var x = -size.height
            while x < size.width {
                path.move(to: CGPoint(x: x, y: size.height))
                path.addLine(to: CGPoint(x: x + size.height, y: 0))
                x += spacing
            }
            context.stroke(path, with: .color(Theme.text.opacity(0.07)), lineWidth: 1)
        }
        .background(Theme.neutral900)
        .overlay(alignment: .bottomLeading) {
            if let caption {
                Text(caption).font(.mono(10)).foregroundStyle(Theme.neutral400).padding(12)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if let stamp {
                Text(stamp).font(.mono(11)).tracking(0.9).foregroundStyle(Theme.accent300).padding(12)
            }
        }
    }
}

/// A sealed disposable-camera shot: blurred grain with a lock.
struct SealedPhoto: View {
    var label = "DEVELOPS AT 10:00 AM"

    var body: some View {
        FilmPhoto(spacing: 12)
            .blur(radius: 6)
            .clipped()
            .overlay {
                VStack(spacing: 6) {
                    Image(systemName: "lock.fill").font(.system(size: 20)).foregroundStyle(Theme.accent)
                    Text(label).font(.mono(12)).tracking(0.5).foregroundStyle(Theme.neutral400)
                }
            }
    }
}

struct Polaroid<Content: View>: View {
    var padding: CGFloat = 8
    var bottom: CGFloat = 32
    var paper: Color = Theme.neutral200
    var rotation: Double = 0
    var caption: String? = nil
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding([.top, .horizontal], padding)
            .padding(.bottom, bottom)
            .background(RoundedRectangle(cornerRadius: 4).fill(paper))
            .overlay(alignment: .bottomLeading) {
                if let caption {
                    Text(caption)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Theme.neutral800)
                        .padding(.leading, padding + 4)
                        .padding(.bottom, bottom / 2 - 6)
                }
            }
            .rotationEffect(.degrees(rotation))
            .shadow(color: .black.opacity(0.5), radius: 15, y: 12)
    }
}

// MARK: - Badges

struct BadgeMedal: View {
    let badge: Badge
    var size: CGFloat = 88

    var body: some View {
        Group {
            if badge.earned {
                Circle()
                    .fill(AngularGradient(
                        colors: [Theme.accent, Theme.accent300, Theme.accent700, Theme.accent],
                        center: .center, angle: .degrees(badge.shimmerAngle)
                    ))
                    .overlay {
                        Circle()
                            .fill(RadialGradient(colors: [Theme.neutral800, Theme.surface], center: UnitPoint(x: 0.35, y: 0.3), startRadius: 0, endRadius: size * 0.5))
                            .padding(size * 0.035)
                    }
                    .overlay {
                        Image(systemName: badge.symbol)
                            .font(.system(size: size * 0.36))
                            .foregroundStyle(Theme.accent200)
                    }
                    .shadow(color: Theme.accent.opacity(0.22), radius: 12)
            } else {
                Circle()
                    .strokeBorder(Theme.neutral700, style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
                    .overlay {
                        Image(systemName: badge.symbol)
                            .font(.system(size: size * 0.32))
                            .foregroundStyle(Theme.neutral600)
                    }
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Stat tile

struct StatTile: View {
    let value: String
    let label: String
    var valueSize: CGFloat = 26

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(value)
                .font(.heading(valueSize))
                .tracking(-0.03 * valueSize)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label).font(.body(12)).foregroundStyle(Theme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 16).fill(Theme.surface))
    }
}

// MARK: - Toast

struct ToastModifier: ViewModifier {
    @Environment(AppState.self) private var app

    func body(content: Content) -> some View {
        content.overlay(alignment: .top) {
            if let message = app.toast {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.accent)
                    Text(message).font(.body(14, weight: .medium))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Capsule().fill(Theme.surface))
                .overlay(Capsule().strokeBorder(Theme.neutral700, lineWidth: 1))
                .shadow(color: .black.opacity(0.5), radius: 9, y: 6)
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.3), value: app.toast)
    }
}

extension View {
    func toasts() -> some View { modifier(ToastModifier()) }
}
