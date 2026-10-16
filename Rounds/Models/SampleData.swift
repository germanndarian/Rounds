import Foundation

/// Static sample content from the design prototype. Replaced by Supabase data later.
enum SampleData {
    static let me = Person(id: "D", name: "Darian", color: Theme.accent700)
    static let amara = Person(id: "A", name: "Amara", color: Theme.neutral700)
    static let lukas = Person(id: "L", name: "Lukas", color: Theme.accent800)
    static let priya = Person(id: "P", name: "Priya", color: Theme.neutral600)
    static let mateo = Person(id: "M", name: "Mateo", color: Theme.accent600)

    static let people = [me, amara, lukas, priya, mateo]

    static let crews = [
        Crew(id: "usual", name: "The Usual Suspects", members: people, memberCount: 5, since: "March 2025", nights: 23, bars: 41, photos: 912),
        Crew(id: "office", name: "Office Thursdays", members: [
            Person(id: "J", name: "Jonas", color: Theme.neutral700),
            Person(id: "S", name: "Sofia", color: Theme.accent800),
            Person(id: "K", name: "Kai", color: Theme.neutral600),
        ], memberCount: 8, since: "May 2025", nights: 9, bars: 12, photos: 140),
        Crew(id: "climbing", name: "Climbing Gang", members: [
            Person(id: "N", name: "Nora", color: Theme.accent600),
            Person(id: "T", name: "Tim", color: Theme.neutral700),
            Person(id: "E", name: "Elif", color: Theme.accent800),
        ], memberCount: 4, since: "June 2025", nights: 6, bars: 8, photos: 96),
    ]

    static let currentBar = "Hinterhof 8"

    static let stops = [
        Stop(number: 1, name: "Café Tram 3", area: "Kreis 5", arrived: "8:06 PM", span: "8:06 – 9:24 PM",
             extra: "6 photos · Priya bought the first round", latitude: 47.3862, longitude: 8.5262),
        Stop(number: 2, name: "Zum Goldenen Hecht", area: "Niederdorf", arrived: "9:30 PM", span: "9:30 – 10:48 PM",
             extra: "9 photos · window table", latitude: 47.3728, longitude: 8.5440),
        Stop(number: 3, name: "Hinterhof 8", area: "Kreis 4", arrived: "11:02 PM", span: "11:02 PM – 12:40 AM",
             extra: "14 photos · longest stop", latitude: 47.3769, longitude: 8.5262),
        Stop(number: 4, name: "Kasernen Club", area: "Kaserne", arrived: "12:48 AM", span: "12:48 – 2:10 AM",
             extra: "8 photos · home by 2:24 AM", latitude: 47.3779, longitude: 8.5322),
    ]

    static let nights = [
        NightSummary(id: "1015", route: "Café Tram 3 → Kasernen Club", date: "Thu, Oct 15", weekday: "Thu", day: "15", meta: "4 bars · 37 photos", stamp: "10 15"),
        NightSummary(id: "1009", route: "Bar Limmatblick → Rosengarten Bar", date: "Fri, Oct 9", weekday: "Fri", day: "9", meta: "3 bars · 22 photos", stamp: "10 09"),
        NightSummary(id: "1003", route: "Seebad Utoquai → Zum Goldenen Hecht", date: "Sat, Oct 3", weekday: "Sat", day: "3", meta: "2 bars · 41 photos", stamp: "10 03"),
        NightSummary(id: "0926", route: "Hinterhof 8", date: "Fri, Sep 26", weekday: "Fri", day: "26", meta: "1 bar · 12 photos", stamp: "09 26"),
        NightSummary(id: "0919", route: "Café Tram 3 → Bar Limmatblick → Kasernen Club", date: "Fri, Sep 19", weekday: "Fri", day: "19", meta: "3 bars · 29 photos", stamp: "09 19"),
    ]

    static let badges = [
        Badge(number: 1, name: "Bar Crawler", symbol: "point.topleft.down.to.point.bottomright.curvepath.fill", earned: true, description: "Four or more bars in one night.", detail: "Earned Oct 15 at Kasernen Club"),
        Badge(number: 2, name: "Globetrotter", symbol: "globe.europe.africa.fill", earned: true, description: "Nights out in four countries.", detail: "Earned Aug 2 in Lisbon"),
        Badge(number: 3, name: "Hydrated", symbol: "drop.fill", earned: true, description: "A water between every round all night.", detail: "Earned Oct 15"),
        Badge(number: 4, name: "Early Bird", symbol: "sunrise.fill", earned: true, description: "Home before midnight on a Friday.", detail: "Earned Sep 5"),
        Badge(number: 5, name: "Night Owl", symbol: "moon.stars.fill", earned: true, description: "Still out past 2 AM with the crew.", detail: "Earned Oct 15"),
        Badge(number: 6, name: "Regular", symbol: "storefront.fill", earned: true, description: "Ten nights at the same bar.", detail: "Earned Sep 26 at Hinterhof 8"),
        Badge(number: 7, name: "Shutterbug", symbol: "film.stack", earned: true, description: "100 disposable shots developed.", detail: "Earned Oct 3"),
        Badge(number: 8, name: "Founder", symbol: "flag.fill", earned: true, description: "Started a crew and brought them out.", detail: "Earned Mar 14, 2025"),
        Badge(number: 9, name: "Marathon", symbol: "shoeprints.fill", earned: false, description: "Eight bars in one night.", detail: "6 of 8 bars"),
        Badge(number: 10, name: "Polyglot", symbol: "character.bubble.fill", earned: false, description: "Nights out in five countries.", detail: "4 of 5 countries"),
        Badge(number: 11, name: "Full Roll", symbol: "camera.aperture", earned: false, description: "Use all 27 shots in one night.", detail: "19 of 27 shots"),
        Badge(number: 12, name: "Four Seasons", symbol: "leaf.fill", earned: false, description: "A night out in every season.", detail: "3 of 4 seasons"),
    ]

    static let songs = [
        Song(rank: 1, title: "Tram Lines at Dawn", artist: "Velvet Kiosk", bar: "Kasernen Club"),
        Song(rank: 2, title: "Neon Seefeld", artist: "Mira Sol", bar: "Hinterhof 8"),
        Song(rank: 3, title: "Last Call (Again)", artist: "The Quiet Hours", bar: "Kasernen Club"),
        Song(rank: 4, title: "Polaroid Summer", artist: "Juno & the Lakes", bar: "Zum Goldenen Hecht"),
        Song(rank: 5, title: "Langstrasse 2AM", artist: "DJ Okapi", bar: "Hinterhof 8"),
    ]

    static let strip: [(bar: String, time: String, rotation: Double)] = [
        ("Café Tram 3", "8:31P", -2), ("Goldenen Hecht", "9:52P", 1.5), ("Hinterhof 8", "11:20P", -1),
        ("Kasernen Club", "1:15A", 2), ("Kasernen Club", "1:58A", -1.5),
    ]

    static func feed(now: Date = .now) -> [FeedItem] {
        func at(_ hour: Int, _ minute: Int) -> Date {
            Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: now) ?? now
        }
        return [
            FeedItem(kind: .drink(.cocktail, name: "Cocktail"), person: priya, bar: "Hinterhof 8", time: at(23, 38), comment: "The yuzu one. Order it."),
            FeedItem(kind: .photo, person: lukas, bar: "Hinterhof 8", time: at(23, 31)),
            FeedItem(kind: .drink(.water, name: "Water"), person: amara, bar: "Hinterhof 8", time: at(23, 24)),
            FeedItem(kind: .system(symbol: "figure.walk", text: "Mateo headed to Bar Limmatblick"), bar: "", time: at(23, 10)),
            FeedItem(kind: .system(symbol: "mappin.and.ellipse", text: "Crew arrived at Hinterhof 8"), bar: "", time: at(22, 54)),
            FeedItem(kind: .photo, person: amara, bar: "Bar Limmatblick", time: at(22, 31), comment: "Window seat crew"),
            FeedItem(kind: .drink(.beer, name: "Beer"), person: me, bar: "Bar Limmatblick", time: at(21, 58), hasPhoto: true),
            FeedItem(kind: .system(symbol: "moon.stars.fill", text: "Night started at Bar Limmatblick"), bar: "", time: at(20, 12)),
        ]
    }
}
