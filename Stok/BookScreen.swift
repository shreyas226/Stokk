import SwiftUI

/// Artboard: "The book" — allocation across the four sectors, and the warning
/// that one of them is carrying the whole thing.
struct BookScreen: View {
    @Binding var selection: AppSection

    private struct Holding: Identifiable {
        let id = UUID()
        let name: String
        let rail: Color
        let meta: String
        var metaTint: Color = Theme.inkMuted
        let value: String
        let week: String
        var weekTint: Color = Theme.inkMuted
        let spark: [CGPoint]
    }

    private let holdings: [Holding] = [
        Holding(
            name: "Craft", rail: Theme.sectorCraft,
            meta: "41% OF BOOK · 38 POSITIONS",
            value: "526.69", week: "+61.20 WK", weekTint: Theme.accent,
            spark: [
                CGPoint(x: 0, y: 22), CGPoint(x: 9, y: 20), CGPoint(x: 18, y: 15),
                CGPoint(x: 27, y: 12), CGPoint(x: 36, y: 6), CGPoint(x: 44, y: 3)
            ]
        ),
        Holding(
            name: "Health", rail: Theme.sectorHealth,
            meta: "34% OF BOOK · 31 POSITIONS",
            value: "436.76", week: "+22.40 WK", weekTint: Theme.accent,
            spark: [
                CGPoint(x: 0, y: 21), CGPoint(x: 9, y: 19), CGPoint(x: 18, y: 17),
                CGPoint(x: 27, y: 13), CGPoint(x: 36, y: 11), CGPoint(x: 44, y: 8)
            ]
        ),
        Holding(
            name: "Mind", rail: Theme.sectorMind,
            meta: "21% OF BOOK · 19 POSITIONS",
            value: "269.77", week: "+8.80 WK",
            spark: [
                CGPoint(x: 0, y: 20), CGPoint(x: 9, y: 17), CGPoint(x: 18, y: 15),
                CGPoint(x: 27, y: 14), CGPoint(x: 36, y: 13), CGPoint(x: 44, y: 13)
            ]
        ),
        Holding(
            name: "Relationships", rail: Theme.sectorPeople,
            meta: "4% OF BOOK · UNDERWEIGHT", metaTint: Theme.amber,
            value: "51.38", week: "+2.00 WK",
            spark: [
                CGPoint(x: 0, y: 16), CGPoint(x: 9, y: 16), CGPoint(x: 18, y: 15),
                CGPoint(x: 27, y: 15), CGPoint(x: 36, y: 15), CGPoint(x: 44, y: 14)
            ]
        )
    ]

    var body: some View {
        ScreenScaffold(
            selection: $selection,
            strip: TopStrip(
                label: "THE BOOK",
                clock: "OPEN · 21 SEP 18:42",
                clockTint: Theme.accent
            ),
            action: PrimaryAction(
                label: "REBALANCE · BUY PEOPLE",
                fill: .clear,
                border: Theme.border,
                tint: Theme.ink
            ) {
                selection = .log
            }
        ) {
            VStack(alignment: .leading, spacing: 15) {
                header
                allocationBar
                holdingsList
                concentrationRisk
                lifetimeStats
            }
        }
    }

    private var header: some View {
        HStack(alignment: .bottom, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text("HOLDINGS")
                    .font(Theme.mono(19, .heavy))
                    .tracking(1.6)
                    .foregroundStyle(Theme.ink)
                Text("FOUR SECTORS · ONE BOOK")
                    .font(Theme.sans(10, .semibold))
                    .tracking(1.3)
                    .foregroundStyle(Theme.inkMuted)
            }
            Spacer(minLength: 0)
            Text("1,284.60")
                .font(Theme.mono(19, .heavy))
                .tracking(-0.8)
                .foregroundStyle(Theme.ink)
        }
    }

    /// The whole book in one 9pt strip.
    private var allocationBar: some View {
        VStack(alignment: .leading, spacing: 9) {
            GeometryReader { geometry in
                let gaps: CGFloat = 2 * 3
                let usable = geometry.size.width - gaps
                HStack(spacing: 2) {
                    segment(Theme.sectorCraft, usable * 0.41, corners: .leading)
                    segment(Theme.sectorHealth, usable * 0.34)
                    segment(Theme.sectorMind, usable * 0.21)
                    segment(Theme.sectorPeople, usable * 0.04, corners: .trailing)
                }
            }
            .frame(height: 9)

            Text("ALLOCATION · CRAFT 41 / HEALTH 34 / MIND 21 / PEOPLE 4")
                .font(Theme.mono(9))
                .tracking(1.1)
                .foregroundStyle(Theme.inkMuted)
        }
    }

    private enum BarEnd { case leading, trailing, none }

    private func segment(_ color: Color, _ width: CGFloat, corners: BarEnd = .none) -> some View {
        UnevenRoundedRectangle(
            topLeadingRadius: corners == .leading ? 2 : 0,
            bottomLeadingRadius: corners == .leading ? 2 : 0,
            bottomTrailingRadius: corners == .trailing ? 2 : 0,
            topTrailingRadius: corners == .trailing ? 2 : 0
        )
        .fill(color)
        .frame(width: max(width, 0), height: 9)
    }

    private var holdingsList: some View {
        VStack(spacing: 0) {
            ForEach(holdings) { holding in
                Hairline()
                HStack(spacing: 11) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(holding.rail)
                        .frame(width: 3, height: 40)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(holding.name)
                            .font(Theme.sans(13.5, .semibold))
                            .foregroundStyle(Theme.ink)
                        Text(holding.meta)
                            .font(Theme.mono(9))
                            .tracking(0.9)
                            .foregroundStyle(holding.metaTint)
                    }
                    Spacer(minLength: 0)
                    Sparkline(points: holding.spark, tint: holding.rail)
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(holding.value)
                            .font(Theme.mono(13.5, .bold))
                            .foregroundStyle(Theme.ink)
                        Text(holding.week)
                            .font(Theme.mono(9.5, .bold))
                            .tracking(0.6)
                            .foregroundStyle(holding.weekTint)
                    }
                }
                .padding(.vertical, 13)
            }
            Hairline()
        }
    }

    private var concentrationRisk: some View {
        HStack(alignment: .top, spacing: 11) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Theme.amber)
                .padding(.top, 1)
            VStack(alignment: .leading, spacing: 6) {
                SectionLabel(text: "CONCENTRATION RISK", tint: Theme.amber)
                Text("Craft carried the week almost alone. Relationships sits at 4% of the book — and a twenty-minute call home is +6.00, the best return per minute available to you today.")
                    .font(Theme.sans(11.5))
                    .lineSpacing(11.5 * 0.5)
                    .foregroundStyle(Theme.inkDim)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.amberBg, in: .rect(cornerRadius: 4))
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Theme.amberBorder, lineWidth: 1))
    }

    private var lifetimeStats: some View {
        VStack(spacing: 0) {
            Hairline()
            HStack(alignment: .top, spacing: 0) {
                statColumn("LISTED", "14 JUN")
                statColumn("GAINED", "+428.60", tint: Theme.accent)
                statColumn("ACTIONS", "96")
                statColumn("BEST DAY", "+31.20")
            }
            .padding(.top, 12)
        }
    }

    private func statColumn(_ label: String, _ value: String, tint: Color = Theme.ink) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(Theme.mono(8.5))
                .tracking(1.1)
                .foregroundStyle(Theme.inkMuted)
            Text(value)
                .font(Theme.mono(12.5, .bold))
                .foregroundStyle(tint)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
