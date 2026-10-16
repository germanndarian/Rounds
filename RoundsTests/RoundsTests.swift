import Foundation
import Testing
@testable import Rounds

@MainActor
struct AppStateTests {
    @Test func loggingADrinkAddsItToTheTopOfTheFeed() {
        let app = AppState()
        let before = app.myDrinksTonight

        let id = app.log(.beer)

        #expect(app.feed.first?.id == id)
        #expect(app.feed.first?.verb == "logged a Beer")
        #expect(app.myDrinksTonight == before + 1)
    }

    @Test func detailsAmendTheLoggedItem() {
        let app = AppState()
        let id = app.log(.custom)

        app.updateLog(id: id, name: "Espresso Martini", comment: "Round on Lukas", hasPhoto: true)

        let item = try! #require(app.feed.first { $0.id == id })
        #expect(item.verb == "logged an Espresso Martini")
        #expect(item.comment == "Round on Lukas")
        #expect(item.hasPhoto)
    }

    @Test func disposableCameraStopsAtZero() {
        let app = AppState()
        app.shotsLeft = 1

        app.takePhoto()
        app.takePhoto()

        #expect(app.shotsLeft == 0)
        #expect(app.shotsTaken == 27)
    }

    @Test func startingANightIsIdempotent() {
        let app = AppState()
        app.startNight()
        let start = app.nightStart

        app.startNight()

        #expect(app.isLive)
        #expect(app.nightStart == start)
        #expect(app.showingLive)
    }

    @Test func checkingInOnlyRecordsTheFirstTime() {
        let app = AppState()
        let first = Date(timeIntervalSince1970: 1_000)

        app.checkIn(now: first)
        app.checkIn(now: first.addingTimeInterval(60))

        #expect(app.checkedInAt == first)
    }
}
