import SwiftUI

/// Disposable camera: no preview after the shot — a short flash, then the frame seals until 10:00.
/// TODO: real capture with AVFoundation; the viewfinder is a placeholder.
struct DisposableCameraView: View {
    @Environment(AppState.self) private var app
    @Environment(\.dismiss) private var dismiss

    @State private var flash = false
    @State private var sealed = false

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(spacing: 0) {
                viewfinder
                shutterBar
            }
            if flash {
                Theme.neutral100.ignoresSafeArea().transition(.opacity)
            }
            if sealed { sealedOverlay.transition(.opacity) }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: app.shotsLeft)
    }

    private var viewfinder: some View {
        FilmPhoto(spacing: 12)
            .overlay { Text("CAMERA VIEWFINDER").font(.mono(11)).tracking(0.7).foregroundStyle(Theme.neutral500) }
            .overlay { CornerBrackets().stroke(Theme.neutral300, lineWidth: 2).padding(.horizontal, 28).padding(.top, 74).padding(.bottom, 28) }
            .overlay(alignment: .bottomTrailing) {
                Text(Date.now.formatted(.dateTime.month(.twoDigits).day(.twoDigits)) + " '" + Date.now.formatted(.dateTime.year(.twoDigits)))
                    .font(.mono(14)).tracking(1.4).foregroundStyle(Theme.accent300).padding(40)
            }
            .overlay(alignment: .top) { topBar }
            .ignoresSafeArea(edges: .top)
    }

    private var topBar: some View {
        HStack {
            CircleIconButton(systemImage: "xmark") { dismiss() }.accessibilityLabel("Close camera")
            Spacer()
            HStack(spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(String(format: "%02d", min(27, app.shotsLeft + 1))).foregroundStyle(Theme.neutral700)
                    Text(String(format: "%02d", app.shotsLeft))
                        .font(.mono(22))
                        .foregroundStyle(Theme.accent200)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(Theme.accent))
                        .contentTransition(.numericText(countsDown: true))
                    Text(String(format: "%02d", max(0, app.shotsLeft - 1))).foregroundStyle(Theme.neutral700)
                }
                .font(.mono(13))
                Text("EXP\nLEFT").font(.mono(9)).tracking(0.9).foregroundStyle(Theme.neutral500)
            }
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(RoundedRectangle(cornerRadius: 10).fill(Theme.bg.opacity(0.8)))
            Spacer()
            CircleIconButton(systemImage: "bolt.fill") {}.accessibilityLabel("Flash")
        }
        .padding(.horizontal, 12)
        .padding(.top, 60)
    }

    private var shutterBar: some View {
        VStack(spacing: 18) {
            Text("DISPOSABLE · \(app.shotsLeft) OF 27 LEFT").font(.mono(11)).tracking(1.5).foregroundStyle(Theme.neutral400)
            HStack {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 8).fill(Theme.neutral800).rotationEffect(.degrees(-8))
                    RoundedRectangle(cornerRadius: 8).fill(Theme.neutral700)
                        .overlay { Image(systemName: "lock.fill").foregroundStyle(Theme.neutral200) }
                    Text("\(app.shotsTaken)")
                        .font(.body(12, weight: .semibold))
                        .padding(.horizontal, 6)
                        .frame(minWidth: 22, minHeight: 22)
                        .background(Capsule().fill(Theme.accent700))
                        .offset(x: 8, y: -8)
                }
                .frame(width: 52, height: 52)
                Spacer()
                Button(action: shoot) {
                    Circle().fill(Theme.neutral200).frame(width: 68, height: 68)
                        .frame(width: 86, height: 86)
                        .overlay(Circle().strokeBorder(Theme.accent, lineWidth: 2))
                        .shadow(color: Theme.accent.opacity(0.35), radius: 15)
                }
                .buttonStyle(ShutterStyle())
                .disabled(app.shotsLeft == 0)
                .accessibilityLabel("Take photo")
                Spacer()
                CircleIconButton(systemImage: "arrow.triangle.2.circlepath.camera", size: 52) {}
                    .accessibilityLabel("Switch camera")
            }
            .padding(.horizontal, 40)
        }
        .padding(.top, 20)
        .frame(height: 200, alignment: .top)
    }

    private var sealedOverlay: some View {
        ZStack {
            Rectangle().fill(.ultraThinMaterial).ignoresSafeArea()
            Theme.bg.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 26) {
                Polaroid(padding: 12, bottom: 52, rotation: -3) {
                    SealedPhoto(label: "SEALED").frame(width: 246, height: 246).clipped()
                }
                .overlay(alignment: .bottom) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Develops at 10:00 tomorrow").font(.body(14, weight: .medium))
                        Spacer()
                        Text("No. \(app.shotsTaken)").font(.mono(10))
                    }
                    .foregroundStyle(Theme.neutral800)
                    .padding(.horizontal, 14).padding(.bottom, 16)
                    .rotationEffect(.degrees(-3))
                }
                .transition(.move(edge: .bottom))
                VStack(spacing: 10) {
                    Button("Keep shooting") { withAnimation { sealed = false } }
                        .buttonStyle(AccentPillStyle(height: 54, glow: false))
                    Button("Back to the night") { dismiss() }
                        .font(.body(15, weight: .medium))
                        .foregroundStyle(Theme.accent300)
                        .frame(height: 44)
                }
                .frame(width: 270)
            }
        }
    }

    private func shoot() {
        guard app.shotsLeft > 0, !flash else { return }
        flash = true
        Task {
            try? await Task.sleep(for: .milliseconds(160))
            withAnimation(.easeOut(duration: 0.3)) {
                flash = false
                app.takePhoto()
            }
            withAnimation(.spring(duration: 0.45, bounce: 0.25)) { sealed = true }
        }
    }
}

private struct ShutterStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.94 : 1)
    }
}

private struct CornerBrackets: Shape {
    var length: CGFloat = 28

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let l = length
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + l)); path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)); path.addLine(to: CGPoint(x: rect.minX + l, y: rect.minY))
        path.move(to: CGPoint(x: rect.maxX - l, y: rect.minY)); path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)); path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + l))
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - l)); path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)); path.addLine(to: CGPoint(x: rect.minX + l, y: rect.maxY))
        path.move(to: CGPoint(x: rect.maxX - l, y: rect.maxY)); path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)); path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - l))
        return path
    }
}
