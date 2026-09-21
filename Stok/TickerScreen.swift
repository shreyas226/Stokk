import SwiftUI

/// Artboard: "Ticker home". Price, chart, momentum, today's contributors.
struct TickerScreen: View {
    @Binding var selection: AppSection
    @State private var range: ChartRange = .threeMonths

    enum ChartRange: String, CaseIterable, Identifiable {
        case day = "1D", week = "1W", month = "1M", threeMonths = "3M", all = "ALL"
        var id: Self { self }
    }

    var body: some View {
        ScreenScaffold(
            selection: $selection,
            strip: TopStrip(
                label: "LIFE INDEX",
                clock: "OPEN · 21 SEP 18:42",
                clockTint: Theme.accent
            ),
            action: PrimaryAction(label: "LOG ACTION", leadingPlus: true) {
                selection = .log
            }
        ) {
            VStack(alignment: .leading, spacing: 14) {
                header
                price
                chart
                rangePicker
                momentum
                contributors
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text("SHRY")
                    .font(Theme.mono(21, .heavy))
                    .tracking(2.5)
                    .foregroundStyle(Theme.ink)
                Text("PERSONAL EQUITY · ONE HOLDER")
                    .font(Theme.sans(10, .semibold))
                    .tracking(1.3)
                    .foregroundStyle(Theme.inkMuted)
            }
            Spacer(minLength: 0)
            streakBadge
        }
    }

    private var streakBadge: some View {
        HStack(spacing: 6) {
            FlameGlyph()
            Text("DAY 12")
                .font(Theme.mono(11, .bold))
                .tracking(1)
        }
        .foregroundStyle(Theme.amber)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Theme.amberBg, in: .rect(cornerRadius: 3))
        .overlay(RoundedRectangle(cornerRadius: 3).stroke(Theme.amberBorderWarm, lineWidth: 1))
    }

    // MARK: - Price

    private var price: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("1,284.60")
                .font(Theme.mono(50, .heavy))
                .tracking(-2.6)
                .foregroundStyle(Theme.ink)

            HStack(spacing: 9) {
                HStack(spacing: 5) {
                    MoveTriangle(direction: .up)
                    Text("18.40")
                }
                .font(Theme.mono(13, .bold))
                .foregroundStyle(Theme.accent)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Theme.accent.opacity(0.13), in: .rect(cornerRadius: 3))

                Text("+1.45%")
                    .font(Theme.mono(13, .medium))
                    .foregroundStyle(Theme.accent)

                Text("TODAY")
                    .font(Theme.sans(10, .semibold))
                    .tracking(1.3)
                    .foregroundStyle(Theme.inkMuted)
            }
        }
    }

    private var chart: some View {
        VStack(alignment: .leading, spacing: 9) {
            IndexChart()
            ChartLegend()
        }
    }

    // MARK: - Range

    private var rangePicker: some View {
        HStack(spacing: 6) {
            ForEach(ChartRange.allCases) { option in
                let isOn = option == range
                Button {
                    range = option
                } label: {
                    Text(option.rawValue)
                        .font(Theme.mono(10.5, .bold))
                        .tracking(1)
                        .foregroundStyle(isOn ? Theme.onAccent : Theme.inkMuted)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                        .background(isOn ? Theme.accent : .clear, in: .rect(cornerRadius: 3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(isOn ? Theme.accent : Theme.border, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isOn ? [.isSelected] : [])
            }
        }
    }

    // MARK: - Momentum
    //
    // The one place red is allowed. The price never falls; this does.

    private var momentum: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack {
                SectionLabel(text: "MOMENTUM · PTS/DAY")
                Spacer()
                HStack(spacing: 5) {
                    MoveTriangle(direction: .down)
                    Text("79%")
                }
                .font(Theme.mono(11, .bold))
                .foregroundStyle(Theme.red)
            }

            HStack(alignment: .firstTextBaseline, spacing: 7) {
                Text("0.4")
                    .font(Theme.mono(29, .heavy))
                    .tracking(-1.2)
                    .foregroundStyle(Theme.red)
                Text("pts/day")
                    .font(Theme.mono(13))
                    .foregroundStyle(Theme.inkMuted)
                Spacer()
                Text("was 1.9")
                    .font(Theme.mono(11))
                    .foregroundStyle(Theme.inkMuted)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.border)
                    Capsule()
                        .fill(Theme.red)
                        .frame(width: geometry.size.width * 0.21)
                }
            }
            .frame(height: 5)

            Text("Your price never falls. This does. One logged action today puts it back above 1.0.")
                .font(Theme.sans(11.5))
                .lineSpacing(11.5 * 0.5)
                .foregroundStyle(Theme.inkDim)
                .fixedSize(horizontal: false, vertical: true)
        }
        .panel(padding: 13)
    }

    // MARK: - Contributors

    private var contributors: some View {
        VStack(spacing: 0) {
            HStack {
                SectionLabel(text: "TODAY'S CONTRIBUTORS")
                Spacer()
                Button {
                    selection = .book
                } label: {
                    Text("ALL HOLDINGS")
                        .font(Theme.sans(9.5, .bold))
                        .tracking(1.2)
                        .foregroundStyle(Theme.accent)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 7)

            ContributorRow(
                rail: Theme.accent,
                title: "Deep work · 90 minutes",
                meta: "CRAFT · 07:10",
                points: "+12.00",
                pointsTint: Theme.accent
            )
            ContributorRow(
                rail: Theme.accent,
                title: "Run · 5 km",
                meta: "HEALTH · 17:55",
                points: "+6.40",
                pointsTint: Theme.accent
            )
            ContributorRow(
                rail: Theme.railIdle,
                title: "Call home",
                titleTint: Theme.inkMuted,
                meta: "RELATIONSHIPS · UNFILLED",
                points: "+6.00",
                pointsTint: Theme.amber
            )
        }
    }
}

/// One line of the contributors list: a coloured rail, a label, a figure.
struct ContributorRow: View {
    let rail: Color
    let title: String
    var titleTint: Color = Theme.ink
    let meta: String
    let points: String
    let pointsTint: Color

    var body: some View {
        VStack(spacing: 0) {
            Hairline()
            HStack(spacing: 11) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(rail)
                    .frame(width: 3, height: 26)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(Theme.sans(12.5, .semibold))
                        .foregroundStyle(titleTint)
                    Text(meta)
                        .font(Theme.mono(9.5))
                        .tracking(0.9)
                        .foregroundStyle(Theme.inkMuted)
                }
                Spacer(minLength: 0)
                Text(points)
                    .font(Theme.mono(13.5, .bold))
                    .foregroundStyle(pointsTint)
            }
            .padding(.vertical, 8)
        }
    }
}
