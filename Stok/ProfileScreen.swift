import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    profileCard

                    GlassSectionHeader(title: "Settings")

                    ForEach(SettingsRow.placeholders) { row in
                        HStack(spacing: 16) {
                            Image(systemName: row.symbol)
                                .font(.body)
                                .foregroundStyle(Theme.teal)
                                .frame(width: 32)
                            Text(row.title).font(.body)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.footnote)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(16)
                        .glassEffect(.regular, in: .rect(cornerRadius: 20))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 96)
            }
            .navigationTitle("Profile")
        }
    }

    private var profileCard: some View {
        VStack(spacing: 14) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 66))
                .foregroundStyle(Theme.teal)

            Text("Your name")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Theme.plotInk)

            Text("Member since 2026")
                .font(.subheadline)
                .foregroundStyle(Theme.plotInkSecondary)

            HStack(spacing: 0) {
                stat(value: "12,480", label: Theme.currencyName)
                divider
                stat(value: "24", label: "Orders")
                divider
                stat(value: "12", label: "Day streak")
            }
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Theme.plotSurface, in: .rect(cornerRadius: 28))
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(.white.opacity(0.08), lineWidth: 1)
        }
    }

    private func stat(value: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.headline.monospacedDigit())
                .foregroundStyle(Theme.plotInk)
            Text(label)
                .font(.caption)
                .foregroundStyle(Theme.plotInkSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var divider: some View {
        Rectangle()
            .fill(.white.opacity(0.12))
            .frame(width: 1, height: 28)
    }
}

struct SettingsRow: Identifiable {
    let id = UUID()
    let title: String
    let symbol: String

    static let placeholders: [SettingsRow] = [
        .init(title: "Account", symbol: "person"),
        .init(title: "Payment methods", symbol: "creditcard"),
        .init(title: "Notifications", symbol: "bell"),
        .init(title: "Appearance", symbol: "paintbrush"),
        .init(title: "Help", symbol: "questionmark.circle")
    ]
}

#Preview {
    ProfileScreen()
}
