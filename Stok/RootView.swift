import SwiftUI

struct RootView: View {
    @State private var selection: AppSection = .ticker

    var body: some View {
        switch selection {
        case .ticker:  TickerScreen(selection: $selection)
        case .log:     LogScreen(selection: $selection)
        case .book:    BookScreen(selection: $selection)
        case .filings: FilingsScreen(selection: $selection)
        }
    }
}

#Preview("Ticker") { RootView() }
