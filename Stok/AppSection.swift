import SwiftUI

/// The four artboards of the canvas, in nav order.
enum AppSection: String, CaseIterable, Identifiable, Hashable {
    case ticker, log, book, filings

    var id: Self { self }

    /// Mono, letter-spaced, as drawn in the nav.
    var title: String {
        switch self {
        case .ticker:  "TICKER"
        case .log:     "LOG"
        case .book:    "BOOK"
        case .filings: "FILINGS"
        }
    }
}
