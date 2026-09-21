import SwiftUI

/// The four nav glyphs, redrawn from the canvas SVGs on their 20x20 grid.
/// Stroke-only, so they take the current foreground colour.
struct NavIcon: View {
    let section: AppSection
    var size: CGFloat = 19

    var body: some View {
        Canvas { context, rect in
            let s = rect.width / 20
            let ink = GraphicsContext.Shading.foreground

            switch section {
            case .ticker:
                // Axes, then the rising trace.
                var axes = Path()
                axes.move(to: CGPoint(x: 3 * s, y: 3 * s))
                axes.addLine(to: CGPoint(x: 3 * s, y: 17 * s))
                axes.addLine(to: CGPoint(x: 17 * s, y: 17 * s))
                context.stroke(axes, with: ink, style: .init(lineWidth: 1.5 * s, lineCap: .round))

                var trace = Path()
                trace.move(to: CGPoint(x: 5 * s, y: 14 * s))
                trace.addLine(to: CGPoint(x: 9 * s, y: 9 * s))
                trace.addLine(to: CGPoint(x: 12 * s, y: 11.4 * s))
                trace.addLine(to: CGPoint(x: 17 * s, y: 5 * s))
                context.stroke(trace, with: ink, style: .init(lineWidth: 1.7 * s, lineCap: .round, lineJoin: .round))

            case .log:
                let ring = Path(ellipseIn: CGRect(x: 2.8 * s, y: 2.8 * s, width: 14.4 * s, height: 14.4 * s))
                context.stroke(ring, with: ink, lineWidth: 1.5 * s)

                var plus = Path()
                plus.move(to: CGPoint(x: 10 * s, y: 6.4 * s))
                plus.addLine(to: CGPoint(x: 10 * s, y: 13.6 * s))
                plus.move(to: CGPoint(x: 6.4 * s, y: 10 * s))
                plus.addLine(to: CGPoint(x: 13.6 * s, y: 10 * s))
                context.stroke(plus, with: ink, style: .init(lineWidth: 1.5 * s, lineCap: .round))

            case .book:
                // A pie with one slice cut: the allocation mark.
                let ring = Path(ellipseIn: CGRect(x: 2.8 * s, y: 2.8 * s, width: 14.4 * s, height: 14.4 * s))
                context.stroke(ring, with: ink, lineWidth: 1.5 * s)

                var slice = Path()
                slice.move(to: CGPoint(x: 10 * s, y: 2.8 * s))
                slice.addLine(to: CGPoint(x: 10 * s, y: 10 * s))
                slice.addLine(to: CGPoint(x: 17.2 * s, y: 10 * s))
                context.stroke(slice, with: ink, lineWidth: 1.5 * s)

            case .filings:
                // A filed document, corner turned.
                var page = Path()
                page.move(to: CGPoint(x: 5 * s, y: 2.8 * s))
                page.addLine(to: CGPoint(x: 11.4 * s, y: 2.8 * s))
                page.addLine(to: CGPoint(x: 15 * s, y: 6.4 * s))
                page.addLine(to: CGPoint(x: 15 * s, y: 17.2 * s))
                page.addLine(to: CGPoint(x: 5 * s, y: 17.2 * s))
                page.closeSubpath()
                context.stroke(page, with: ink, style: .init(lineWidth: 1.5 * s, lineJoin: .round))

                var lines = Path()
                lines.move(to: CGPoint(x: 8 * s, y: 10 * s))
                lines.addLine(to: CGPoint(x: 12 * s, y: 10 * s))
                lines.move(to: CGPoint(x: 8 * s, y: 13 * s))
                lines.addLine(to: CGPoint(x: 12 * s, y: 13 * s))
                context.stroke(lines, with: ink, style: .init(lineWidth: 1.5 * s, lineCap: .round))
            }
        }
        .frame(width: size, height: size)
    }
}
