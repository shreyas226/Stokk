import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    PlotCard()

                    GlassSectionHeader(title: "Recent activity")

                    ForEach(Activity.placeholders) { activity in
                        ActivityRow(activity: activity)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 96)
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Search", systemImage: "magnifyingglass") {}
                }
            }
        }
    }
}

struct Activity: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let amount: Int
    let symbol: String

    static let placeholders: [Activity] = [
        .init(title: "Daily streak", subtitle: "Today", amount: 120, symbol: "flame"),
        .init(title: "Marketplace refund", subtitle: "Yesterday", amount: 45, symbol: "arrow.uturn.backward"),
        .init(title: "Coffee voucher", subtitle: "2 days ago", amount: -300, symbol: "cup.and.saucer"),
        .init(title: "Referral bonus", subtitle: "4 days ago", amount: 500, symbol: "person.2"),
        .init(title: "Weekly challenge", subtitle: "Last week", amount: 250, symbol: "trophy")
    ]
}

struct ActivityRow: View {
    let activity: Activity

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: activity.symbol)
                .font(.title3)
                .foregroundStyle(Theme.teal)
                .frame(width: 44, height: 44)
                .glassEffect(.regular, in: .circle)

            VStack(alignment: .leading, spacing: 2) {
                Text(activity.title).font(.headline)
                Text(activity.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(activity.amount, format: .number.sign(strategy: .always()))
                .font(.headline.monospacedDigit())
                .foregroundStyle(activity.amount >= 0 ? .primary : .secondary)
        }
        .padding(16)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
}

/// Small section label used across the tabs.
struct GlassSectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
        }
        .padding(.top, 4)
    }
}

#Preview {
    HomeScreen()
}
