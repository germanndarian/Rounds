import Foundation
import Observation

enum AppTab: Hashable { case home, crew, map, profile }

/// In-memory app state driving the prototype UI. Backed by sample data until Supabase is wired up.
@MainActor
@Observable
final class AppState {
    var tab: AppTab = .home
    var showingLive = false
    var showingRecap = false
    var hasCrews = true

    // Live night
    var nightStart: Date?
    var feed: [FeedItem] = SampleData.feed()
    var myDrinksTonight = 4
    var buyerIndex = 3
    var isSpinning = false
    var shotsLeft = 24

    // Get home safe
    var checkedInAt: Date?
    var nudged = false
    var showsBAC = true

    var toast: String?
    private var toastTask: Task<Void, Never>?

    var isLive: Bool { nightStart != nil }
    var crew: Crew { SampleData.crews[0] }
    var buyer: Person { crew.members[buyerIndex % crew.members.count] }
    var shotsTaken: Int { 27 - shotsLeft }

    func startNight() {
        if nightStart == nil {
            nightStart = .now
            show(toast: "Night started at \(SampleData.currentBar)")
        }
        hasCrews = true
        showingLive = true
    }

    /// One-tap log. Returns the new item's id so the details sheet can amend it.
    @discardableResult
    func log(_ kind: DrinkKind, now: Date = .now) -> UUID {
        let item = FeedItem(kind: .drink(kind, name: kind == .custom ? "Custom drink" : kind.label),
                            person: SampleData.me, bar: SampleData.currentBar, time: now)
        feed.insert(item, at: 0)
        myDrinksTonight += 1
        return item.id
    }

    func updateLog(id: UUID, name: String?, comment: String, hasPhoto: Bool) {
        guard let index = feed.firstIndex(where: { $0.id == id }) else { return }
        if let name, !name.isEmpty, case .drink(let kind, _) = feed[index].kind {
            feed[index].kind = .drink(kind, name: name)
        }
        feed[index].comment = comment.isEmpty ? nil : comment
        feed[index].hasPhoto = hasPhoto
    }

    func takePhoto(now: Date = .now) {
        guard shotsLeft > 0 else { return }
        shotsLeft -= 1
        feed.insert(FeedItem(kind: .photo, person: SampleData.me, bar: SampleData.currentBar, time: now), at: 0)
    }

    /// Slot-reel through the crew, slowing down over ~1.2s.
    func spinBuyer() async {
        guard !isSpinning else { return }
        isSpinning = true
        let steps = Int.random(in: 12...16)
        for step in 0..<steps {
            buyerIndex = (buyerIndex + 1) % crew.members.count
            try? await Task.sleep(for: .milliseconds(60 + step * 6))
        }
        isSpinning = false
    }

    func checkIn(now: Date = .now) {
        guard checkedInAt == nil else { return }
        checkedInAt = now
        show(toast: "The crew knows you're home")
    }

    func show(toast message: String) {
        toastTask?.cancel()
        toast = message
        toastTask = Task {
            try? await Task.sleep(for: .seconds(1.8))
            guard !Task.isCancelled else { return }
            toast = nil
        }
    }
}
