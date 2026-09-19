import SwiftUI

struct MarketplaceScreen: View {
    private let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(MarketItem.placeholders) { item in
                        MarketCard(item: item)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 96)
            }
            .navigationTitle("Market")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Filter", systemImage: "line.3.horizontal.decrease") {}
                }
            }
        }
    }
}

struct MarketItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let symbol: String

    static let placeholders: [MarketItem] = [
        .init(name: "Gift card", price: 1_200, symbol: "giftcard"),
        .init(name: "Coffee", price: 300, symbol: "cup.and.saucer"),
        .init(name: "Tote bag", price: 2_400, symbol: "bag"),
        .init(name: "Headphones", price: 9_800, symbol: "headphones"),
        .init(name: "Sticker pack", price: 150, symbol: "seal"),
        .init(name: "Event pass", price: 4_500, symbol: "ticket")
    ]
}

struct MarketCard: View {
    let item: MarketItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: item.symbol)
                .font(.system(size: 34))
                .foregroundStyle(Theme.teal)
                .frame(maxWidth: .infinity, minHeight: 90)
                .background(Theme.plotSurface, in: .rect(cornerRadius: 16))

            Text(item.name)
                .font(.subheadline.weight(.semibold))

            Label {
                Text(item.price, format: .number)
                    .font(.footnote.monospacedDigit())
            } icon: {
                Image(systemName: Theme.currencySymbol)
                    .foregroundStyle(Theme.teal)
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .padding(14)
        .glassEffect(.regular, in: .rect(cornerRadius: 22))
    }
}

#Preview {
    MarketplaceScreen()
}
