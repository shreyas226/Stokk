import SwiftUI

// MARK: - Screen chrome

/// The 32pt strip across the top of every artboard: a label on the left,
/// the market clock on the right.
struct TopStrip: View {
    let label: String
    let clock: String
    var clockTint: Color = Theme.inkMuted

    var body: some View {
        HStack {
            Text(label)
                .font(Theme.mono(10, .bold))
                .tracking(1.6)
                .foregroundStyle(Theme.inkMuted)
            Spacer()
            Text(clock)
                .font(Theme.mono(10, .medium))
                .tracking(0.9)
                .foregroundStyle(clockTint)
        }
        .padding(.horizontal, 20)
        .frame(height: 32)
        .background(Theme.barBg)
        .overlay(alignment: .bottom) { Hairline() }
    }
}

/// The primary nav. Drawn flat rather than as a system tab bar, because the
/// canvas specifies its own height, ground and mono labels.
struct BottomNav: View {	
    @Binding var selection: AppSection

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppSection.allCases) { section in
                let isCurrent = section == selection
                Button {
                    selection = section
                } label: {
                    VStack(spacing: 5) {
                        NavIcon(section: section)
                        Text(section.title)
                            .font(Theme.mono(8.5, .bold))
                            .tracking(1)
                    }
                    .foregroundStyle(isCurrent ? Theme.accent : Theme.inkMuted)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(section.title.capitalized)
                .accessibilityAddTraits(isCurrent ? [.isSelected] : [])
            }
        }
        .frame(height: 62)
        .background(Theme.barBg)
        .overlay(alignment: .top) { Hairline() }
    }
}

/// The 50pt action that sits above the nav on every screen.
struct PrimaryAction: View {
    let label: String
    var fill: Color = Theme.accent
    var border: Color = Theme.accent
    var tint: Color = Theme.onAccent
    var leadingPlus = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 9) {
                if leadingPlus {
                    Image(systemName: "plus")
                        .font(.system(size: 13, weight: .bold))
                }
                Text(label)
                    .font(Theme.mono(12.5, .heavy))
                    .tracking(1.7)
            }
            .foregroundStyle(tint)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(fill, in: .rect(cornerRadius: 4))
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(border, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.top, 14)
    }
}

// MARK: - Small parts

/// A 1px rule in the separator tone.
struct Hairline: View {
    var color: Color = Theme.hairline
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: 1)
    }
}

/// A mono all-caps section label.
struct SectionLabel: View {
    let text: String
    var size: CGFloat = 9.5
    var tracking: CGFloat = 1.5
    var tint: Color = Theme.inkMuted

    var body: some View {
        Text(text)
            .font(Theme.mono(size, .bold))
            .tracking(tracking)
            .foregroundStyle(tint)
    }
}

/// The filled triangle that marks a move. Up for the price, down for anything
/// that is falling — momentum, earnings against the prior week.
struct MoveTriangle: View {
    enum Direction { case up, down }
    let direction: Direction
    var size: CGFloat = 9

    var body: some View {
        Canvas { context, rect in
            let s = rect.width / 9
            var path = Path()
            switch direction {
            case .up:
                path.move(to: CGPoint(x: 4.5 * s, y: 0.6 * s))
                path.addLine(to: CGPoint(x: 8.6 * s, y: 7.9 * s))
                path.addLine(to: CGPoint(x: 0.4 * s, y: 7.9 * s))
            case .down:
                path.move(to: CGPoint(x: 4.5 * s, y: 8.4 * s))
                path.addLine(to: CGPoint(x: 0.4 * s, y: 1.1 * s))
                path.addLine(to: CGPoint(x: 8.6 * s, y: 1.1 * s))
            }
            path.closeSubpath()
            context.fill(path, with: .foreground)
        }
        .frame(width: size, height: size)
    }
}

/// The streak flame in the DAY 12 badge.
struct FlameGlyph: View {
    var body: some View {
        Canvas { context, rect in
            let sx = rect.width / 10, sy = rect.height / 12
            var path = Path()
            path.move(to: CGPoint(x: 5 * sx, y: 0.8 * sy))
            path.addCurve(
                to: CGPoint(x: 8.6 * sx, y: 7.4 * sy),
                control1: CGPoint(x: 5 * sx, y: 4 * sy),
                control2: CGPoint(x: 8.6 * sx, y: 4.2 * sy)
            )
            path.addArc(
                center: CGPoint(x: 5 * sx, y: 7.4 * sy),
                radius: 3.6 * sy,
                startAngle: .degrees(0),
                endAngle: .degrees(180),
                clockwise: false
            )
            path.addCurve(
                to: CGPoint(x: 3.2 * sx, y: 3.6 * sy),
                control1: CGPoint(x: 1.4 * sx, y: 5.6 * sy),
                control2: CGPoint(x: 2.6 * sx, y: 4.6 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 4.6 * sx, y: 5.4 * sy),
                control1: CGPoint(x: 3.5 * sx, y: 4.6 * sy),
                control2: CGPoint(x: 4.2 * sx, y: 5 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 5 * sx, y: 0.8 * sy),
                control1: CGPoint(x: 5 * sx, y: 4.4 * sy),
                control2: CGPoint(x: 5 * sx, y: 2.6 * sy)
            )
            context.stroke(path, with: .foreground, style: .init(lineWidth: 1.1, lineJoin: .round))
        }
        .frame(width: 10, height: 12)
    }
}

/// A small caps pill: MISS / MET / BEAT, HOLD, CONCENTRATION RISK.
struct StatusPill: View {
    let text: String
    let tint: Color
    var fill: Color
    var width: CGFloat?

    var body: some View {
        Text(text)
            .font(Theme.mono(9, .bold))
            .tracking(0.8)
            .foregroundStyle(tint)
            .frame(width: width)
            .padding(.vertical, 3)
            .background(fill, in: .rect(cornerRadius: 2))
    }
}

// MARK: - Layout helpers

/// Card ground: the #131519 panel with a #232830 edge.
extension View {
    func panel(padding: CGFloat = 14) -> some View {
        self
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.card, in: .rect(cornerRadius: 4))
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Theme.border, lineWidth: 1))
    }

    /// The body column inside every artboard: 20pt gutters, 18pt from the strip.
    func screenBody() -> some View {
        self
            .padding(.horizontal, 20)
            .padding(.top, 18)
    }
}
