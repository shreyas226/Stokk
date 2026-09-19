import SwiftUI

struct NotificationsScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(AppNotification.placeholders) { note in
                        NotificationRow(note: note)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 96)
            }
            .navigationTitle("Alerts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Mark all read", systemImage: "checkmark") {}
                }
            }
        }
    }
}

struct AppNotification: Identifiable {
    let id = UUID()
    let title: String
    let body: String
    let time: String
    let symbol: String
    let isUnread: Bool

    static let placeholders: [AppNotification] = [
        .init(title: "Points credited", body: "500 \(Theme.currencyName) landed in your balance.",
              time: "2m", symbol: "arrow.down.circle", isUnread: true),
        .init(title: "Order shipped", body: "Your tote bag is on the way.",
              time: "1h", symbol: "shippingbox", isUnread: true),
        .init(title: "Streak at risk", body: "Check in today to keep your 12-day streak.",
              time: "5h", symbol: "flame", isUnread: false),
        .init(title: "New in Market", body: "Event passes just went live.",
              time: "Yesterday", symbol: "sparkles", isUnread: false),
        .init(title: "Security", body: "New sign-in from a new device.",
              time: "3d", symbol: "lock.shield", isUnread: false)
    ]
}

struct NotificationRow: View {
    let note: AppNotification

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: note.symbol)
                .font(.title3)
                .foregroundStyle(Theme.teal)
                .frame(width: 44, height: 44)
                .glassEffect(.regular, in: .circle)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(note.title).font(.headline)
                    if note.isUnread {
                        Circle()
                            .fill(Theme.teal)
                            .frame(width: 7, height: 7)
                    }
                    Spacer()
                    Text(note.time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(note.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
}

#Preview {
    NotificationsScreen()
}
