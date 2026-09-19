import Charts
import SwiftUI

/// The hero plotting area: a near-black card carrying one teal series.
/// Drag across it to scrub — the headline number follows your finger.
struct PlotCard: View {
    @State private var range: PlotRange = .month
    @State private var scrubbed: BalancePoint?

    private var points: [BalancePoint] { BalanceSeries.sample(for: range) }

    /// What the headline shows: the scrubbed point, else the latest.
    private var displayed: BalancePoint? { scrubbed ?? points.last }

    private var change: Double {
        guard let first = points.first?.value, let last = displayed?.value, first != 0 else { return 0 }
        return (last - first) / first * 100
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header
            plot
            rangePicker
        }
        .padding(20)
        .background(Theme.plotSurface)
        .clipShape(.rect(cornerRadius: 28))
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(.white.opacity(0.08), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.25), radius: 20, y: 10)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            // One series, so the title names it instead of a legend.
            Text("\(Theme.currencyName) balance")
                .font(.subheadline)
                .foregroundStyle(Theme.plotInkSecondary)

            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(displayed?.value ?? 0, format: .number.precision(.fractionLength(0)))
                    .font(.system(size: 40, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.plotInk)
                    .contentTransition(.numericText())

                changeChip
            }

            Text(scrubbed.map { $0.date.formatted(date: .abbreviated, time: .shortened) }
                 ?? "Past \(range.rawValue)")
                .font(.caption)
                .foregroundStyle(Theme.plotInkSecondary)
        }
    }

    /// Colour carries identity on the glyph; the number stays in ink.
    private var changeChip: some View {
        HStack(spacing: 4) {
            Image(systemName: change >= 0 ? "arrow.up.right" : "arrow.down.right")
                .foregroundStyle(Theme.teal)
            Text(abs(change), format: .number.precision(.fractionLength(1)))
                .foregroundStyle(Theme.plotInk)
            Text("%")
                .foregroundStyle(Theme.plotInkSecondary)
        }
        .font(.footnote.weight(.semibold))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Theme.teal.opacity(0.18), in: .capsule)
    }

    // MARK: - Plot

    private var plot: some View {
        Chart {
            ForEach(points) { point in
                AreaMark(
                    x: .value("Date", point.date),
                    y: .value(Theme.currencyName, point.value)
                )
                .foregroundStyle(
                    .linearGradient(
                        colors: [Theme.teal.opacity(0.35), Theme.teal.opacity(0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)

                LineMark(
                    x: .value("Date", point.date),
                    y: .value(Theme.currencyName, point.value)
                )
                .foregroundStyle(Theme.teal)
                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .interpolationMethod(.catmullRom)
            }

            if let scrubbed {
                RuleMark(x: .value("Date", scrubbed.date))
                    .foregroundStyle(.white.opacity(0.25))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [3, 3]))

                PointMark(
                    x: .value("Date", scrubbed.date),
                    y: .value(Theme.currencyName, scrubbed.value)
                )
                .symbolSize(90)
                .foregroundStyle(Theme.teal)
                // 2px surface ring keeps the marker off the line beneath it.
                .annotation(position: .overlay) {
                    Circle()
                        .strokeBorder(Theme.plotSurface, lineWidth: 2)
                        .frame(width: 14, height: 14)
                }
            }
        }
        .chartYScale(domain: yDomain)
        .chartYAxis {
            AxisMarks(position: .trailing, values: .automatic(desiredCount: 4)) {
                AxisGridLine().foregroundStyle(Theme.plotGrid)
                AxisValueLabel()
                    .font(.caption2)
                    .foregroundStyle(Theme.plotInkSecondary)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 4)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date, format: range.dateFormat)
                            .font(.caption2)
                            .foregroundStyle(Theme.plotInkSecondary)
                    }
                }
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(.clear)
                    .contentShape(.rect)
                    .gesture(scrubGesture(proxy: proxy, geometry: geometry))
            }
        }
        // Keep the plot area short of the frame so the x labels sit below the
        // area fill instead of on top of it.
        .chartPlotStyle { $0.frame(height: 156).clipped() }
        .frame(height: 190)
        .clipped()
        .animation(.easeInOut(duration: 0.25), value: range)
    }

    /// Pad the domain a little so the line never touches the card edges.
    private var yDomain: ClosedRange<Double> {
        let values = points.map(\.value)
        guard let low = values.min(), let high = values.max(), low < high else { return 0...1 }
        let padding = (high - low) * 0.18
        return (low - padding)...(high + padding)
    }

    private func scrubGesture(proxy: ChartProxy, geometry: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { drag in
                guard let plotFrame = proxy.plotFrame else { return }
                let origin = geometry[plotFrame].origin
                guard let date = proxy.value(atX: drag.location.x - origin.x, as: Date.self) else { return }
                scrubbed = points.min {
                    abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
                }
            }
            .onEnded { _ in
                withAnimation(.easeOut) { scrubbed = nil }
            }
    }

    // MARK: - Range picker

    private var rangePicker: some View {
        HStack(spacing: 8) {
            ForEach(PlotRange.allCases) { option in
                let isSelected = option == range
                Button {
                    withAnimation(.snappy) {
                        range = option
                        scrubbed = nil
                    }
                } label: {
                    Text(option.rawValue)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(isSelected ? Theme.plotSurface : Theme.plotInkSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background {
                            if isSelected {
                                Capsule().fill(Theme.teal)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(.white.opacity(0.06), in: .capsule)
    }
}

#Preview {
    PlotCard()
        .padding()
}
