import MapKit
import SwiftUI

struct NightMapView: View {
    @Environment(AppState.self) private var app
    @State private var selected = 0

    private var stop: Stop { SampleData.stops[selected] }

    var body: some View {
        RouteMap(selected: selected, interactive: true) { selected = $0 }
            .ignoresSafeArea(edges: .top)
            .safeAreaInset(edge: .top) { header }
            .safeAreaInset(edge: .bottom) { stopCard }
            .sensoryFeedback(.selection, trigger: selected)
    }

    private var header: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Night map").font(.heading(20))
                Text("Thu, Oct 15 · \(SampleData.stops.count) stops · 3.9 km").font(.body(13)).foregroundStyle(Theme.neutral400)
            }
            Spacer()
            Button("Recap") { app.showingRecap = true }
                .buttonStyle(AccentPillStyle(height: 40, fontSize: 14, fill: false, glow: false))
        }
        .padding(.leading, 18).padding(.trailing, 12).padding(.vertical, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 26))
        .padding(.horizontal, 12)
    }

    private var stopCard: some View {
        HStack(spacing: 14) {
            Text("\(stop.number)")
                .font(.heading(20)).foregroundStyle(Theme.accent200)
                .frame(width: 44, height: 44)
                .overlay(Circle().strokeBorder(Theme.accent, lineWidth: 1.5))
            VStack(alignment: .leading, spacing: 2) {
                Text(stop.name).font(.heading(18))
                Text("\(stop.area) · \(stop.span)").font(.body(13)).foregroundStyle(Theme.neutral400)
                Text(stop.extra).font(.body(13)).foregroundStyle(Theme.neutral500)
            }
            Spacer()
            HStack(spacing: 6) {
                stepButton("chevron.left", label: "Previous stop") { selected = (selected + SampleData.stops.count - 1) % SampleData.stops.count }
                stepButton("chevron.right", label: "Next stop") { selected = (selected + 1) % SampleData.stops.count }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 26))
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
        .animation(.snappy, value: selected)
    }

    private func stepButton(_ symbol: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol).frame(width: 40, height: 40).overlay(Circle().strokeBorder(Theme.divider))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

/// Dark MapKit map with the night's route and numbered stops. Shared by the Map tab and the recap.
struct RouteMap: View {
    let selected: Int?
    var interactive = true
    var onSelect: (Int) -> Void = { _ in }

    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $position, interactionModes: interactive ? .all : []) {
            MapPolyline(coordinates: SampleData.stops.map(\.coordinate))
                .stroke(Theme.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            ForEach(Array(SampleData.stops.enumerated()), id: \.element.id) { index, stop in
                Annotation(stop.name, coordinate: stop.coordinate, anchor: .center) {
                    pin(stop, isSelected: index == selected)
                        .onTapGesture { onSelect(index) }
                }
                .annotationTitles(interactive ? .automatic : .hidden)
            }
        }
        .mapStyle(.standard(elevation: .flat, emphasis: .muted, pointsOfInterest: .excludingAll))
        .environment(\.colorScheme, .dark)
        .onChange(of: selected) { _, index in
            guard let index else { return }
            withAnimation(.easeInOut(duration: 0.6)) {
                position = .camera(MapCamera(centerCoordinate: SampleData.stops[index].coordinate, distance: 2200))
            }
        }
    }

    private func pin(_ stop: Stop, isSelected: Bool) -> some View {
        Text("\(stop.number)")
            .font(.body(isSelected ? 16 : 13, weight: .semibold))
            .foregroundStyle(isSelected ? Theme.bg : Theme.accent200)
            .frame(width: isSelected ? 40 : 30, height: isSelected ? 40 : 30)
            .background(Circle().fill(isSelected ? Theme.accent : Theme.bg))
            .overlay(Circle().strokeBorder(Theme.accent, lineWidth: 2))
            .background(Circle().fill(Theme.accent.opacity(isSelected ? 0.25 : 0)).padding(-6))
            .shadow(color: .black.opacity(0.5), radius: 8, y: 6)
            .animation(.spring(duration: 0.25), value: isSelected)
    }
}

#Preview {
    NightMapView()
        .environment(AppState())
        .preferredColorScheme(.dark)
}
