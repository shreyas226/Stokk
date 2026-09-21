import SwiftUI

/// Artboard: "Weekly earnings" — what you said you would do, what you did,
/// and the note that refuses to soften it.
struct FilingsScreen: View {
    @Binding var selection: AppSection

    private struct Line: Identifiable {
        let id = UUID()
        let name: String
        let said: String
        let did: String
        let verdict: Verdict
    }

    private enum Verdict {
        case miss, met, beat

        var label: String {
            switch self {
            case .miss: "MISS"
            case .met:  "MET"
            case .beat: "BEAT"
            }
        }

        var tint: Color {
            switch self {
            case .miss: Theme.red
            case .met:  Theme.inkDim
            case .beat: Theme.accent
            }
        }

        var fill: Color {
            switch self {
            case .miss: Theme.red.opacity(0.15)
            case .met:  Theme.chip
            case .beat: Theme.accent.opacity(0.15)
            }
        }
    }

    private let lines: [Line] = [
        Line(name: "Deep work blocks", said: "10", did: "7", verdict: .miss),
        Line(name: "Training sessions", said: "4", did: "4", verdict: .met),
        Line(name: "Nights with 7h sleep", said: "6", did: "3", verdict: .miss),
        Line(name: "Calls home", said: "2", did: "1", verdict: .miss),
        Line(name: "Pages read", said: "120", did: "168", verdict: .beat)
    ]

    var body: some View {
        ScreenScaffold(
            selection: $selection,
            strip: TopStrip(label: "FILINGS", clock: "FILED 21 SEP 06:00"),
            action: PrimaryAction(label: "START WEEK 39") {
                selection = .log
            }
        ) {
            VStack(alignment: .leading, spacing: 14) {
                header
                earnings
                scorecard
                analystNote
                guidance
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("WEEK 38")
                    .font(Theme.mono(19, .heavy))
                    .tracking(1.4)
                    .foregroundStyle(Theme.ink)
                Text("14 – 20 SEP 2026 · EARNINGS")
                    .font(Theme.sans(10, .semibold))
                    .tracking(1.3)
                    .foregroundStyle(Theme.inkMuted)
            }
            Spacer(minLength: 0)
            Text("HOLD")
                .font(Theme.mono(11, .heavy))
                .tracking(1.4)
                .foregroundStyle(Theme.amber)
                .padding(.horizontal, 11)
                .padding(.vertical, 6)
                .background(Theme.amberBg, in: .rect(cornerRadius: 3))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Theme.amberBorder, lineWidth: 1))
        }
    }

    private var earnings: some View {
        HStack(alignment: .bottom, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                SectionLabel(text: "POINTS EARNED")
                Text("+94.40")
                    .font(Theme.mono(34, .heavy))
                    .tracking(-1.6)
                    .foregroundStyle(Theme.accent)
            }
            Spacer(minLength: 0)
            VStack(alignment: .trailing, spacing: 6) {
                HStack(spacing: 5) {
                    MoveTriangle(direction: .down)
                    Text("34%")
                }
                .font(Theme.mono(11, .bold))
                .foregroundStyle(Theme.red)

                Text("PRIOR WK +142.80")
                    .font(Theme.mono(10))
                    .tracking(0.6)
                    .foregroundStyle(Theme.inkMuted)
            }
        }
        .panel()
    }

    // MARK: - Said / did

    private var scorecard: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                SectionLabel(text: "VS YOUR OWN GUIDANCE", size: 9, tracking: 1.4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                columnHead("SAID")
                columnHead("DID")
                Color.clear.frame(width: 46, height: 1)
            }
            .padding(.bottom, 8)

            ForEach(lines) { line in
                Hairline()
                HStack(spacing: 8) {
                    Text(line.name)
                        .font(Theme.sans(12.5, .medium))
                        .foregroundStyle(Theme.ink)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(line.said)
                        .font(Theme.mono(12.5))
                        .foregroundStyle(Theme.inkMuted)
                        .frame(width: 40, alignment: .trailing)
                    Text(line.did)
                        .font(Theme.mono(12.5, .bold))
                        .foregroundStyle(Theme.ink)
                        .frame(width: 40, alignment: .trailing)
                    StatusPill(
                        text: line.verdict.label,
                        tint: line.verdict.tint,
                        fill: line.verdict.fill,
                        width: 46
                    )
                }
                .padding(.vertical, 8)
            }
            Hairline()
        }
    }

    private func columnHead(_ text: String) -> some View {
        Text(text)
            .font(Theme.mono(9, .bold))
            .tracking(0.8)
            .foregroundStyle(Theme.inkMuted)
            .frame(width: 40, alignment: .trailing)
    }

    private var analystNote: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionLabel(text: "ANALYST NOTE")
            Text("Fundamentals intact, execution slipped. Craft carried the week almost alone — that is concentration, not strength. The three sleep misses show up two days later in output every single time; the correlation is no longer arguable.")
            Text("Nothing here is broken. You stopped showing up on the days you did not feel like it.")
        }
        .font(Theme.sans(12.5))
        .lineSpacing(12.5 * 0.55)
        .foregroundStyle(Theme.inkSoft)
        .panel()
    }

    // MARK: - Next week

    private var guidance: some View {
        VStack(spacing: 0) {
            SectionLabel(text: "GUIDANCE · WEEK 39", size: 9, tracking: 1.4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)

            guidanceRow("Deep work blocks", "8 · CUT FROM 10", tint: Theme.accent)
            guidanceRow("Nights with 7h sleep", "5", tint: Theme.accent)
            guidanceRow("Calls home", "2 · NON-NEGOTIABLE", tint: Theme.amber)
            Hairline()
        }
    }

    private func guidanceRow(_ name: String, _ target: String, tint: Color) -> some View {
        VStack(spacing: 0) {
            Hairline()
            HStack(spacing: 10) {
                Text(name)
                    .font(Theme.sans(12.5, .medium))
                    .foregroundStyle(Theme.ink)
                Spacer(minLength: 0)
                Text(target)
                    .font(Theme.mono(11, .bold))
                    .tracking(0.6)
                    .foregroundStyle(tint)
            }
            .padding(.vertical, 7)
        }
    }
}
