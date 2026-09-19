import SwiftUI

/// The five tabs of the app.
enum AppSection: String, CaseIterable, Identifiable, Hashable {
    case home, marketplace, add, notifications, profile

    var id: Self { self }

    var title: String {
        switch self {
        case .home:          "Home"
        case .marketplace:   "Market"
        case .add:           "Add"
        case .notifications: "Alerts"
        case .profile:       "Profile"
        }
    }

    var symbol: String {
        switch self {
        case .home:          "house"
        case .marketplace:   "bag"
        case .add:           "plus.circle"
        case .notifications: "bell"
        case .profile:       "person.crop.circle"
        }
    }
}
