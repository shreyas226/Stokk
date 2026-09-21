import SwiftUI

/// Design tokens taken straight from the Life Index canvas.
/// Every hex here appears literally in one of the four artboards.
enum Theme {

    // MARK: - Surfaces

    /// Page ground.
    static let bg = Color(hex: 0x0A0B0D)
    /// Status strip and bottom nav.
    static let barBg = Color(hex: 0x0E1013)
    /// Raised card.
    static let card = Color(hex: 0x131519)
    /// Selected chip fill.
    static let chip = Color(hex: 0x1C222A)

    // MARK: - Lines

    /// Row separators and bar edges.
    static let hairline = Color(hex: 0x1B1F26)
    /// Card and control borders.
    static let border = Color(hex: 0x232830)
    /// Unselected checkbox stroke.
    static let stroke = Color(hex: 0x39414B)
    /// The arrow between price and momentum.
    static let arrow = Color(hex: 0x4B525B)
    /// An unfilled contributor's rail.
    static let railIdle = Color(hex: 0x3A3730)

    // MARK: - Ink

    static let ink = Color(hex: 0xE8E6E1)
    /// Analyst-note body.
    static let inkSoft = Color(hex: 0xD6D3CD)
    /// Explanatory paragraphs.
    static let inkDim = Color(hex: 0xA8AEB6)
    /// Labels, metadata, dimmed numbers.
    static let inkMuted = Color(hex: 0x8A9099)

    // MARK: - Signal

    /// The one accent. Price, gains, the primary action.
    static let accent = Color(hex: 0x3FCF8E)
    /// Ink that sits on top of the accent.
    static let onAccent = Color(hex: 0x071A11)
    /// Warning: underweight, unfilled, non-negotiable.
    static let amber = Color(hex: 0xE8B339)
    static let amberBg = Color(hex: 0x16130C)
    static let amberBorder = Color(hex: 0x3A3018)
    /// Streak-badge border — one shade warmer than the rest.
    static let amberBorderWarm = Color(hex: 0x2E2A1C)
    /// Red lives on momentum and on misses. Never on the chart.
    static let red = Color(hex: 0xE5534B)

    /// Sector ramp, darkening down the allocation bar.
    static let sectorCraft = Color(hex: 0x3FCF8E)
    static let sectorHealth = Color(hex: 0x35B67C)
    static let sectorMind = Color(hex: 0x27855C)
    static let sectorPeople = Color(hex: 0xE8B339)

    // MARK: - Type
    //
    // The canvas draws in Archivo (sans) over JetBrains Mono (figures).
    // Neither ships with iOS, so the system faces stand in: SF Pro for the
    // sans, SF Mono for every figure, label and ticker string. Swap the two
    // helpers below if the real families ever get bundled.

    static func mono(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }

    static func sans(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight)
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}
