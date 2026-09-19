import SwiftUI

enum Theme {
    /// Series colour for every plot. Validated against a dark plot surface:
    /// OKLCH L 0.63 (inside the 0.48–0.67 dark band), chroma above floor,
    /// contrast > 3:1. Don't lighten it past L 0.67 or it leaves the band.
    static let teal = Color(red: 0.071, green: 0.647, blue: 0.580)   // #12A594

    /// Near-black plotting surface.
    static let plotSurface = Color(red: 0.043, green: 0.043, blue: 0.051)  // #0B0B0D

    /// Ink on the plot surface — text never wears the series colour.
    static let plotInk = Color.white
    static let plotInkSecondary = Color.white.opacity(0.6)
    static let plotGrid = Color.white.opacity(0.08)

    /// The in-app currency. Renamed in one place once it's decided.
    static let currencyName = "Points"
    static let currencySymbol = "circle.hexagongrid.fill"
}
