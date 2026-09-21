import SwiftUI

/// Artboard: "Log an action" — the interactive one. Pick a sector, tick what
/// you will actually do, and watch the order preview price it before you commit.
struct LogScreen: View {
    @Binding var selection: AppSection
    @State private var sector: Sector = .craft
    @State private var picked: Set<String> = ["c1"]

    // MARK: - Derived figures

    private var total: Double {
        ActionCatalog.bySector.values
            .flatMap { $0 }
            .filter { picked.contains($0.id) }
            .reduce(0) { $0 + $1.points }
    }

    private var newPrice: Double { ActionCatalog.basePrice + total }

    /// Every point logged today buys back 0.08 pts/day of momentum.
    private var newMomentum: Double { ActionCatalog.baseMomentum + total * 0.08 }

    private var momentumLabel: String { String(format: "%.1f", newMomentum) }

    private var momentumTint: Color { newMomentum >= 1.0 ? Theme.accent : Theme.amber }

    private var advice: String {
        guard total > 0 else {
            return "Nothing selected. The price holds at \(indexFormat(ActionCatalog.basePrice)) — and a price that only holds is a price that stops meaning anything."
        }
        let days = max(1, Int(((ActionCatalog.target - newPrice) / newMomentum).rounded(.up)))
        return "Momentum returns to \(momentumLabel) pts/day. Hold that and you clear \(indexFormat(ActionCatalog.target)) in \(days) days."
    }

    private func count(in sector: Sector) -> Int {
        ActionCatalog.actions(in: sector).filter { picked.contains($0.id) }.count
    }

    // MARK: - Body

    var body: some View {
        ScreenScaffold(
            selection: $selection,
            strip: TopStrip(
                label: "NEW POSITION",
                clock: "OPEN · 21 SEP 18:42",
                clockTint: Theme.accent
            ),
            action: commitAction
        ) {
            VStack(alignment: .leading, spacing: 15) {
                header
                sectorPicker
                actionList
                // The canvas floats this card to the bottom of the body.
                Spacer(minLength: 0)
                orderPreview
            }
        }
    }

    @ViewBuilder
    private var commitAction: some View {
        if total == 0 {
            PrimaryAction(
                label: "SELECT AT LEAST ONE",
                fill: .clear,
                border: Theme.border,
                tint: Theme.inkMuted
            ) {}
                .disabled(true)
        } else {
            PrimaryAction(label: "EXECUTE · +\(String(format: "%.2f", total))") {
                selection = .ticker
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text("BUY SHRY")
                    .font(Theme.mono(19, .heavy))
                    .tracking(1.6)
                    .foregroundStyle(Theme.ink)
                Text("PICK WHAT YOU WILL ACTUALLY DO")
                    .font(Theme.sans(10, .semibold))
                    .tracking(1.3)
                    .foregroundStyle(Theme.inkMuted)
            }
            Spacer(minLength: 0)
            Button {
                selection = .ticker
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 11, weight: .semibold))
                    Text("TICKER")
                        .font(Theme.mono(10, .bold))
                        .tracking(1.1)
                }
                .foregroundStyle(Theme.inkMuted)
                .frame(height: 44)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Sectors

    private var sectorPicker: some View {
        HStack(spacing: 6) {
            ForEach(Sector.allCases) { option in
                let isOn = option == sector
                let picks = count(in: option)
                Button {
                    sector = option
                } label: {
                    Text(picks > 0 ? "\(option.label) \(picks)" : option.label)
                        .font(Theme.mono(9.5, .bold))
                        .tracking(0.9)
                        .foregroundStyle(isOn ? Theme.ink : Theme.inkMuted)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(isOn ? Theme.chip : .clear, in: .rect(cornerRadius: 3))
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

    // MARK: - Positions

    private var actionList: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionLabel(text: "AVAILABLE POSITIONS · \(sector.label)")
            ForEach(ActionCatalog.actions(in: sector)) { action in
                positionRow(action)
            }
        }
    }

    private func positionRow(_ action: LogAction) -> some View {
        let isOn = picked.contains(action.id)
        return Button {
            if isOn { picked.remove(action.id) } else { picked.insert(action.id) }
        } label: {
            HStack(spacing: 12) {
                checkbox(isOn: isOn)
                VStack(alignment: .leading, spacing: 3) {
                    Text(action.label)
                        .font(Theme.sans(13, .semibold))
                        .foregroundStyle(Theme.ink)
                        .multilineTextAlignment(.leading)
                    Text(action.meta)
                        .font(Theme.mono(9.5))
                        .tracking(0.9)
                        .foregroundStyle(Theme.inkMuted)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
                Text("+\(String(format: "%.2f", action.points))")
                    .font(Theme.mono(13.5, .bold))
                    .foregroundStyle(isOn ? Theme.accent : Theme.inkMuted)
            }
            .padding(.horizontal, 13)
            .padding(.vertical, 11)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                isOn ? Theme.accent.opacity(0.08) : Theme.card,
                in: .rect(cornerRadius: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isOn ? Theme.accent : Theme.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isOn ? [.isSelected] : [])
    }

    private func checkbox(isOn: Bool) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(isOn ? Theme.accent : .clear)
            .frame(width: 20, height: 20)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(isOn ? Theme.accent : Theme.stroke, lineWidth: 1.5)
            )
            .overlay {
                if isOn {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Theme.onAccent)
                }
            }
    }

    // MARK: - Order preview

    private var orderPreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(text: "ORDER PREVIEW")

            HStack(alignment: .bottom, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("PRICE")
                        .font(Theme.mono(9.5))
                        .tracking(1.1)
                        .foregroundStyle(Theme.inkMuted)
                    Text(indexFormat(newPrice))
                        .font(Theme.mono(23, .heavy))
                        .tracking(-1)
                        .foregroundStyle(Theme.ink)
                }
                Spacer(minLength: 0)
                Image(systemName: "arrow.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Theme.arrow)
                    .padding(.bottom, 4)
                Spacer(minLength: 0)
                VStack(alignment: .trailing, spacing: 4) {
                    Text("MOMENTUM")
                        .font(Theme.mono(9.5))
                        .tracking(1.1)
                        .foregroundStyle(Theme.inkMuted)
                    Text(momentumLabel)
                        .font(Theme.mono(23, .heavy))
                        .tracking(-1)
                        .foregroundStyle(momentumTint)
                }
            }

            Hairline(color: Theme.border)

            Text(advice)
                .font(Theme.sans(11.5))
                .lineSpacing(11.5 * 0.5)
                .foregroundStyle(Theme.inkDim)
                .fixedSize(horizontal: false, vertical: true)
        }
        .panel()
    }
}
