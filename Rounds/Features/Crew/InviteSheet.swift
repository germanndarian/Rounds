import CoreImage.CIFilterBuiltins
import SwiftUI

struct InviteSheet: View {
    let crew: Crew
    @Environment(\.dismiss) private var dismiss
    @State private var copied = false

    // TODO(backend): generate per-crew invite tokens in Supabase.
    private let link = URL(string: "https://rounds.app/j/usual-7KQ2")!

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Invite to \(crew.name)").font(.heading(20))
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.neutral300)
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Theme.text.opacity(0.08)))
                }
                .accessibilityLabel("Close")
            }

            if let qr = Self.qrImage(for: link.absoluteString) {
                Image(uiImage: qr)
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 190, height: 190)
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Theme.neutral100))
            }
            Text("Scan with the iPhone camera to join").font(.body(13)).foregroundStyle(Theme.neutral400)

            HStack(spacing: 10) {
                Image(systemName: "link").foregroundStyle(Theme.neutral400)
                Text(link.host() ?? "").font(.mono(14)).foregroundStyle(Theme.neutral200)
                    + Text(link.path()).font(.mono(14)).foregroundStyle(Theme.neutral200)
                Spacer()
                Button(copied ? "Copied" : "Copy") {
                    UIPasteboard.general.url = link
                    copied = true
                    Task {
                        try? await Task.sleep(for: .seconds(1.5))
                        copied = false
                    }
                }
                .font(.body(14, weight: .medium))
                .foregroundStyle(Theme.text)
                .padding(.horizontal, 14)
                .frame(height: 40)
                .background(Capsule().fill(Theme.text.opacity(0.08)))
                .sensoryFeedback(.success, trigger: copied) { _, new in new }
            }
            .padding(.leading, 16)
            .padding(.trailing, 6)
            .frame(height: 52)
            .overlay(Capsule().strokeBorder(Theme.divider))

            ShareLink(item: link, message: Text("Join \(crew.name) on Rounds")) {
                Label("Share invite link", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(AccentPillStyle(glow: false))

            Text("Anyone with the link can join for 7 days.").font(.body(12)).foregroundStyle(Theme.neutral500)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 12)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.surface)
    }

    static func qrImage(for string: String) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"
        guard let output = filter.outputImage,
              let cgImage = CIContext().createCGImage(output, from: output.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
