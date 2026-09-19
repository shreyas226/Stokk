import SwiftUI

struct RootView: View {
    @State private var selection: AppSection = .home

    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppSection.allCases) { section in
                Tab(section.title, systemImage: section.symbol, value: section) {
                    screen(for: section)
                }
            }
        }
        // Liquid Glass: the tab bar shrinks away as content scrolls up,
        // then floats back over the content on scroll down.
        .tabBarMinimizeBehavior(.onScrollDown)
        .tint(Theme.teal)
    }

    @ViewBuilder
    private func screen(for section: AppSection) -> some View {
        switch section {
        case .home:          HomeScreen()
        case .marketplace:   MarketplaceScreen()
        case .add:           AddPointsScreen()
        case .notifications: NotificationsScreen()
        case .profile:       ProfileScreen()
        }
    }
}

#Preview {
    RootView()
}
