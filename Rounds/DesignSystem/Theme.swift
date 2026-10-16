import SwiftUI

/// Nocturne design tokens (see the Claude Design project's `styles.css`).
/// Dark-ground system: near-black surfaces, one blurple accent used as line and glow.
enum Theme {
    // Core
    static let bg = Color(hex: 0x161826)
    static let surface = Color(hex: 0x232532)
    static let text = Color(hex: 0xE9E9ED)
    static let accent = Color(hex: 0x9184D9)
    static let divider = text.opacity(0.16)
    static let muted = text.opacity(0.58)

    // Neutral ramp
    static let neutral100 = Color(hex: 0xF3F5FE)
    static let neutral200 = Color(hex: 0xE4E7F5)
    static let neutral300 = Color(hex: 0xCFD3E5)
    static let neutral400 = Color(hex: 0xB2B6CA)
    static let neutral500 = Color(hex: 0x9397AB)
    static let neutral600 = Color(hex: 0x75798C)
    static let neutral700 = Color(hex: 0x595D6C)
    static let neutral800 = Color(hex: 0x3F424D)
    static let neutral900 = Color(hex: 0x292B31)

    // Accent ramp
    static let accent100 = Color(hex: 0xF5F4FF)
    static let accent200 = Color(hex: 0xE7E5FE)
    static let accent300 = Color(hex: 0xD2CEFD)
    static let accent600 = Color(hex: 0x796CBF)
    static let accent700 = Color(hex: 0x5D5294)
    static let accent800 = Color(hex: 0x423A6A)
    static let accent900 = Color(hex: 0x2B2741)

    // Deep indigo grounds for hero moments (onboarding, live night, recap intro)
    static let section = Color(hex: 0x262A60)
    static let sectionGlow = Color(hex: 0x353B80)

    // Radii
    static let radiusCard: CGFloat = 22
    static let radiusTile: CGFloat = 18
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

extension Font {
    /// Headings use medium weight with tight tracking (apply `.tracking` at the call site for display sizes).
    static func heading(_ size: CGFloat) -> Font { .system(size: size, weight: .medium) }
    static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font { .system(size: size, weight: weight) }
    /// Film-stamp / metadata style.
    static func mono(_ size: CGFloat) -> Font { .system(size: size, weight: .medium, design: .monospaced) }
}

extension View {
    /// Radial indigo glow from the top used on hero screens.
    func nocturneHeroBackground(height: CGFloat = 0.45) -> some View {
        background {
            ZStack {
                Theme.bg
                RadialGradient(
                    colors: [Theme.section.opacity(0.75), .clear],
                    center: .top, startRadius: 0, endRadius: 520
                )
                .scaleEffect(x: 1.3, y: height * 2, anchor: .top)
            }
            .ignoresSafeArea()
        }
    }
}
