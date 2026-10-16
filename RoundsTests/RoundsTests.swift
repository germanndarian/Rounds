import Testing
@testable import Rounds

struct RoundsTests {
    @Test func appLaunchesWithoutBackendConfigured() {
        #expect(Backend.client == nil)
    }
}
