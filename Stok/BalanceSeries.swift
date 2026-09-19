import Foundation

struct BalancePoint: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let value: Double
}

enum PlotRange: String, CaseIterable, Identifiable {
    case day = "1D", week = "1W", month = "1M", quarter = "3M", year = "1Y"

    var id: Self { self }

    /// How many samples to draw, and how far apart.
    var sampleCount: Int {
        switch self {
        case .day:     24
        case .week:    28
        case .month:   30
        case .quarter: 45
        case .year:    52
        }
    }

    var step: TimeInterval {
        switch self {
        case .day:     3600
        case .week:    6 * 3600
        case .month:   24 * 3600
        case .quarter: 2 * 24 * 3600
        case .year:    7 * 24 * 3600
        }
    }

    /// Axis label format for this span.
    var dateFormat: Date.FormatStyle {
        switch self {
        case .day:                  .dateTime.hour()
        case .week, .month:         .dateTime.month(.abbreviated).day()
        case .quarter, .year:       .dateTime.month(.abbreviated)
        }
    }
}

/// Placeholder series. Deterministic — seeded so the plot looks the same on
/// every launch. Swap this for the real balance history when the API exists.
enum BalanceSeries {
    static func sample(for range: PlotRange, now: Date = .now) -> [BalancePoint] {
        var generator = SeededGenerator(seed: UInt64(range.sampleCount) &* 2_654_435_761)
        var value = 8_400.0
        let drift = 42.0

        return (0..<range.sampleCount).reversed().map { offset in
            let noise = Double.random(in: -110...150, using: &generator)
            value += drift + noise
            return BalancePoint(
                date: now.addingTimeInterval(-Double(offset) * range.step),
                value: max(value, 0)
            )
        }
    }
}

/// Small linear congruential generator, so the placeholder data is stable.
private struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) { state = seed == 0 ? 0x9E3779B9 : seed }

    mutating func next() -> UInt64 {
        state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
        return state
    }
}
