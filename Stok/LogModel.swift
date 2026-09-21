import Foundation

/// A sector of the book. The four buckets every action falls into.
enum Sector: String, CaseIterable, Identifiable, Hashable {
    case health = "HEALTH"
    case craft = "CRAFT"
    case mind = "MIND"
    case people = "PEOPLE"

    var id: Self { self }
    var label: String { rawValue }
}

/// One position you can open: a thing you might actually do today.
struct LogAction: Identifiable, Hashable {
    let id: String
    let label: String
    let meta: String
    let points: Double
}

/// The catalog behind the log screen, sector by sector.
enum ActionCatalog {
    /// Yesterday's close, and the pace it is running at.
    static let basePrice = 1284.60
    static let baseMomentum = 0.4
    /// The next round number worth clearing.
    static let target = 1500.0

    static let bySector: [Sector: [LogAction]] = [
        .health: [
            LogAction(id: "h1", label: "Run · 5 km", meta: "CARDIO · 35 MIN", points: 6.4),
            LogAction(id: "h2", label: "Strength session", meta: "GYM · 45 MIN", points: 7.2),
            LogAction(id: "h3", label: "Seven hours of sleep", meta: "RECOVERY · COMPOUNDS", points: 4.0),
            LogAction(id: "h4", label: "Cook instead of ordering", meta: "FUEL · 30 MIN", points: 2.8)
        ],
        .craft: [
            LogAction(id: "c1", label: "Deep work block", meta: "90 MIN · PHONE IN ANOTHER ROOM", points: 12.0),
            LogAction(id: "c2", label: "Ship something, any size", meta: "PUBLIC · HIGHEST YIELD", points: 15.0),
            LogAction(id: "c3", label: "Study block", meta: "45 MIN · NEW MATERIAL", points: 5.6),
            LogAction(id: "c4", label: "Fix the thing you keep avoiding", meta: "BACKLOG · 20 MIN", points: 4.2)
        ],
        .mind: [
            LogAction(id: "m1", label: "Journal, unfiltered", meta: "10 MIN", points: 3.2),
            LogAction(id: "m2", label: "Read 20 pages", meta: "A BOOK, NOT A FEED", points: 4.4),
            LogAction(id: "m3", label: "Phone off after 22:00", meta: "COMPOUNDS NIGHTLY", points: 5.0),
            LogAction(id: "m4", label: "Walk with nothing in your ears", meta: "20 MIN · NO AUDIO", points: 3.6)
        ],
        .people: [
            LogAction(id: "p1", label: "Call home", meta: "20 MIN · OVERDUE 6 DAYS", points: 6.0),
            LogAction(id: "p2", label: "Conversation, phone face down", meta: "45 MIN", points: 4.8),
            LogAction(id: "p3", label: "Help someone unprompted", meta: "ANY SIZE", points: 7.5),
            LogAction(id: "p4", label: "Answer the message you dodged", meta: "2 MIN · CHEAPEST POINTS HERE", points: 2.4)
        ]
    ]

    static func actions(in sector: Sector) -> [LogAction] {
        bySector[sector] ?? []
    }
}

/// Grouped thousands, two decimals — the way every figure in the canvas prints.
func indexFormat(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    formatter.decimalSeparator = "."
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
}
