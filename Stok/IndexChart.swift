import SwiftUI

/// The ninety-day index trace: a line that only ever rises, and a dashed
/// projection of the pace it has fallen away from. Drawn on the canvas's own
/// 350x110 grid and scaled to whatever width it gets.
struct IndexChart: View {
    /// The trace, in artboard coordinates.
    private static let trace: [CGPoint] = [
        CGPoint(x: 0, y: 103), CGPoint(x: 27, y: 98), CGPoint(x: 54, y: 91),
        CGPoint(x: 81, y: 83), CGPoint(x: 108, y: 73), CGPoint(x: 135, y: 61),
        CGPoint(x: 162, y: 51), CGPoint(x: 189, y: 40), CGPoint(x: 216, y: 33),
        CGPoint(x: 243, y: 26), CGPoint(x: 270, y: 23), CGPoint(x: 297, y: 20),
        CGPoint(x: 324, y: 18), CGPoint(x: 350, y: 17)
    ]

    /// Where the 14 Sep pace would have carried it.
    private static let pace: [CGPoint] = [
        CGPoint(x: 243, y: 26), CGPoint(x: 297, y: 14), CGPoint(x: 350, y: 4)
    ]

    private static let designSize = CGSize(width: 350, height: 110)

    var body: some View {
        Canvas { context, rect in
            let sx = rect.width / Self.designSize.width
            let sy = rect.height / Self.designSize.height
            func p(_ point: CGPoint) -> CGPoint {
                CGPoint(x: point.x * sx, y: point.y * sy)
            }

            // Two dotted guides and the baseline.
            for y in [37.0, 73.0] {
                var rule = Path()
                rule.move(to: p(CGPoint(x: 0, y: y)))
                rule.addLine(to: p(CGPoint(x: 350, y: y)))
                context.stroke(
                    rule,
                    with: .color(Theme.hairline),
                    style: .init(lineWidth: 1, dash: [2, 5])
                )
            }
            var base = Path()
            base.move(to: p(CGPoint(x: 0, y: 109)))
            base.addLine(to: p(CGPoint(x: 350, y: 109)))
            context.stroke(base, with: .color(Theme.border), lineWidth: 1)

            // The trace, closed down to the floor and filled.
            var line = Path()
            line.addLines(Self.trace.map(p))

            var area = line
            area.addLine(to: p(CGPoint(x: 350, y: 110)))
            area.addLine(to: p(CGPoint(x: 0, y: 110)))
            area.closeSubpath()
            context.fill(
                area,
                with: .linearGradient(
                    Gradient(colors: [Theme.accent.opacity(0.26), Theme.accent.opacity(0)]),
                    startPoint: .zero,
                    endPoint: CGPoint(x: 0, y: rect.height)
                )
            )

            // The pace it left behind. Grey, never red — the price never falls.
            var paceLine = Path()
            paceLine.addLines(Self.pace.map(p))
            context.stroke(
                paceLine,
                with: .color(Theme.inkMuted.opacity(0.8)),
                style: .init(lineWidth: 1.3, dash: [4, 4])
            )

            context.stroke(
                line,
                with: .color(Theme.accent),
                style: .init(lineWidth: 2.3, lineCap: .round, lineJoin: .round)
            )

            // Today.
            let head = p(Self.trace[Self.trace.count - 1])
            let dot = Path(ellipseIn: CGRect(
                x: head.x - 3.4, y: head.y - 3.4, width: 6.8, height: 6.8
            ))
            context.fill(dot, with: .color(Theme.accent))
        }
        .frame(height: 110)
        .accessibilityElement()
        .accessibilityLabel(
            "Life index over ninety days: a line rising from 856 to 1,284.60 that flattens sharply over the final two weeks, falling away from a dashed line showing the earlier pace."
        )
    }
}

/// The legend beneath the chart.
struct ChartLegend: View {
    var body: some View {
        HStack(spacing: 18) {
            legendItem("Actual") {
                Rectangle()
                    .fill(Theme.accent)
                    .frame(width: 15, height: 2)
            }
            legendItem("Your 14 Sep pace") {
                DashedRule()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [3, 3]))
                    .foregroundStyle(Theme.inkMuted)
                    .frame(width: 15, height: 2)
            }
        }
    }

    private func legendItem(
        _ label: String,
        @ViewBuilder swatch: () -> some View
    ) -> some View {
        HStack(spacing: 6) {
            swatch()
            Text(label.uppercased())
                .font(Theme.sans(9.5, .semibold))
                .tracking(1)
                .foregroundStyle(Theme.inkMuted)
        }
    }
}

/// A horizontal rule the legend can dash.
struct DashedRule: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}

/// A sector's 44x26 sparkline in the book.
struct Sparkline: View {
    let points: [CGPoint]
    let tint: Color

    var body: some View {
        Canvas { context, rect in
            let sx = rect.width / 44, sy = rect.height / 26
            var path = Path()
            path.addLines(points.map { CGPoint(x: $0.x * sx, y: $0.y * sy) })
            context.stroke(
                path,
                with: .color(tint),
                style: .init(lineWidth: 1.6, lineCap: .round, lineJoin: .round)
            )
        }
        .frame(width: 44, height: 26)
    }
}
