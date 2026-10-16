import SwiftUI

struct LogDraft: Identifiable {
    let id: UUID
    let kind: DrinkKind
    let time: Date
}

/// Optional details after a one-tap log. Every field is optional; skipping keeps the plain log.
struct LogDrinkSheet: View {
    let draft: LogDraft
    @Environment(AppState.self) private var app
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var comment = ""
    @State private var hasPhoto = false
    @State private var scan = ScanState.idle

    private enum ScanState { case idle, scanning, found }

    private var title: String {
        switch (draft.kind, scan) {
        case (.custom, _): (name.isEmpty ? "Custom drink" : name) + " logged"
        case (_, .found): "Feldschlösschen logged"
        default: "\(draft.kind.label) logged"
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: draft.kind.symbol)
                        .font(.system(size: 22))
                        .foregroundStyle(Theme.accent200)
                        .frame(width: 48, height: 48)
                        .background(Circle().fill(Theme.accent.opacity(0.14)))
                        .overlay(Circle().strokeBorder(Theme.accent))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title).font(.heading(20))
                        Text("\(draft.time.formatted(date: .omitted, time: .shortened)) · add details if you like")
                            .font(.body(13)).foregroundStyle(Theme.neutral500)
                    }
                    Spacer()
                }

                if draft.kind == .custom {
                    TextField("What are you having?", text: $name)
                        .font(.body(16))
                        .padding(.horizontal, 16)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Theme.bg))
                        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Theme.divider))
                }

                VStack(spacing: 0) {
                    // TODO: PhotosPicker / camera capture.
                    Button { hasPhoto.toggle() } label: {
                        row {
                            if hasPhoto {
                                FilmPhoto(spacing: 6).frame(width: 36, height: 36).clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                rowIcon("photo.badge.plus")
                            }
                        } title: {
                            Text(hasPhoto ? "Photo attached" : "Add a photo")
                        } trailing: {
                            if hasPhoto { Text("Remove") }
                        }
                    }
                    .buttonStyle(.plain)
                    FadingDivider()
                    // TODO: Core Location + MapKit POI search.
                    row {
                        rowIcon("mappin.and.ellipse")
                    } title: {
                        VStack(alignment: .leading, spacing: 1) {
                            Text(SampleData.currentBar)
                            Text("Detected nearby · Langstrasse 120").font(.body(12)).foregroundStyle(Theme.neutral500)
                        }
                    } trailing: {
                        Text("Change")
                    }
                    FadingDivider()
                    // TODO: VisionKit DataScannerViewController.
                    Button(action: startScan) {
                        row {
                            rowIcon(scan == .found ? "checkmark.circle.fill" : "barcode.viewfinder")
                        } title: {
                            switch scan {
                            case .idle: Text("Scan barcode")
                            case .scanning: Text("Scanning…")
                            case .found: Text("Feldschlösschen Original · 4.8%")
                            }
                        } trailing: { EmptyView() }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 14)
                .background(RoundedRectangle(cornerRadius: 16).fill(Theme.text.opacity(0.05)))

                TextField("Add a comment", text: $comment, axis: .vertical)
                    .lineLimit(2...4)
                    .font(.body(16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Theme.bg))
                    .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Theme.divider))

                Button("Save", action: save)
                    .buttonStyle(AccentPillStyle(glow: false))
                    .padding(.top, 4)
                Button("Skip, it's already logged") { dismiss() }
                    .font(.body(15, weight: .medium))
                    .foregroundStyle(Theme.neutral400)
                    .frame(height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
        }
        .scrollBounceBehavior(.basedOnSize)
        .presentationDetents([.height(draft.kind == .custom ? 640 : 580), .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.surface)
    }

    private func rowIcon(_ symbol: String) -> some View {
        Image(systemName: symbol).font(.system(size: 20)).foregroundStyle(Theme.accent300).frame(width: 36)
    }

    private func row<Leading: View, Title: View, Trailing: View>(
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder title: () -> Title,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        HStack(spacing: 12) {
            leading()
            title().font(.body(16)).frame(maxWidth: .infinity, alignment: .leading)
            trailing().font(.body(14)).foregroundStyle(Theme.accent300)
        }
        .frame(minHeight: 58)
        .contentShape(Rectangle())
    }

    private func startScan() {
        guard scan == .idle else { return }
        scan = .scanning
        Task {
            try? await Task.sleep(for: .seconds(1.2))
            scan = .found
        }
    }

    private func save() {
        let finalName: String? = draft.kind == .custom ? name : (scan == .found ? "Feldschlösschen" : nil)
        app.updateLog(id: draft.id, name: finalName, comment: comment, hasPhoto: hasPhoto)
        app.show(toast: "Saved to the night")
        dismiss()
    }
}
