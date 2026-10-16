import CoreLocation
import SwiftUI

struct Person: Identifiable, Hashable {
    let id: String
    let name: String
    let color: Color
    var initial: String { String(name.prefix(1)) }
}

struct Crew: Identifiable, Hashable {
    let id: String
    let name: String
    let members: [Person]
    let memberCount: Int
    let since: String
    let nights: Int
    let bars: Int
    let photos: Int
}

enum DrinkKind: String, CaseIterable, Identifiable {
    case beer, wine, shot, cocktail, water, custom

    var id: String { rawValue }

    var label: String { rawValue.capitalized }

    // TODO(design): replace with custom drink glyphs; SF Symbols has no shot or martini glass.
    var symbol: String {
        switch self {
        case .beer: "mug.fill"
        case .wine: "wineglass.fill"
        case .shot: "flask.fill"
        case .cocktail: "party.popper.fill"
        case .water: "drop.fill"
        case .custom: "plus"
        }
    }
}

struct FeedItem: Identifiable {
    enum Kind {
        case drink(DrinkKind, name: String)
        case photo
        case system(symbol: String, text: String)
    }

    let id: UUID
    var kind: Kind
    var person: Person?
    var bar: String
    var time: Date
    var comment: String?
    var hasPhoto = false

    init(id: UUID = UUID(), kind: Kind, person: Person? = nil, bar: String, time: Date, comment: String? = nil, hasPhoto: Bool = false) {
        self.id = id
        self.kind = kind
        self.person = person
        self.bar = bar
        self.time = time
        self.comment = comment
        self.hasPhoto = hasPhoto
    }

    var verb: String {
        switch kind {
        case .drink(_, let name):
            let article = name.lowercased().first.map { "aeiou".contains($0) } == true ? "an" : "a"
            return "logged \(article) \(name)"
        case .photo: return "took a photo"
        case .system(_, let text): return text
        }
    }

    var symbol: String {
        switch kind {
        case .drink(let kind, _): kind.symbol
        case .photo: "camera.fill"
        case .system(let symbol, _): symbol
        }
    }
}

struct Stop: Identifiable, Hashable {
    let number: Int
    let name: String
    let area: String
    let arrived: String
    let span: String
    let extra: String
    let latitude: Double
    let longitude: Double

    var id: Int { number }
    var coordinate: CLLocationCoordinate2D { .init(latitude: latitude, longitude: longitude) }
}

struct NightSummary: Identifiable, Hashable {
    let id: String
    let route: String
    let date: String
    let weekday: String
    let day: String
    let meta: String
    let stamp: String
}

struct Badge: Identifiable, Hashable {
    let number: Int
    let name: String
    let symbol: String
    let earned: Bool
    let description: String
    let detail: String

    var id: Int { number }
    var code: String { String(format: "NO. %02d", number) }
    var shimmerAngle: Double { Double((number - 1) * 47 % 360) }
}

struct Song: Identifiable, Hashable {
    let rank: Int
    let title: String
    let artist: String
    let bar: String
    var id: Int { rank }
}

enum CheckInStatus { case home(String), out(String), notCheckedIn(String) }
