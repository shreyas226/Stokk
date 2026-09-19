import SwiftUI

/// Add currency. The currency itself is still undecided — it's named once in
/// `Theme.currencyName`, so renaming it is a one-line change.
struct AddPointsScreen: View {
    @State private var amount: Int = 500
    @Namespace private var glassNamespace

    private let presets = [100, 500, 1_000, 5_000]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    amountCard
                    presetGrid
                    confirmButton
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 96)
            }
            .navigationTitle("Add \(Theme.currencyName)")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }

    private var amountCard: some View {
        VStack(spacing: 10) {
            Image(systemName: Theme.currencySymbol)
                .font(.system(size: 40))
                .foregroundStyle(Theme.teal)

            Text(amount, format: .number)
                .font(.system(size: 52, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.plotInk)
                .contentTransition(.numericText())

            Text(Theme.currencyName)
                .font(.subheadline)
                .foregroundStyle(Theme.plotInkSecondary)

            Stepper("Amount", value: $amount, in: 0...100_000, step: 50)
                .labelsHidden()
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        // The card is always dark, so system controls on it (the stepper)
        // need the dark scheme to stay visible in light mode.
        .environment(\.colorScheme, .dark)
        .background(Theme.plotSurface, in: .rect(cornerRadius: 28))
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(.white.opacity(0.08), lineWidth: 1)
        }
    }

    private var presetGrid: some View {
        GlassEffectContainer(spacing: 12) {
            HStack(spacing: 12) {
                ForEach(presets, id: \.self) { preset in
                    Button {
                        withAnimation(.snappy) { amount = preset }
                    } label: {
                        Text(preset, format: .number)
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.glass)
                    .glassEffectID(preset, in: glassNamespace)
                }
            }
        }
    }

    private var confirmButton: some View {
        Button {
        } label: {
            Label("Add \(Theme.currencyName)", systemImage: "plus")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.glassProminent)
        .tint(Theme.teal)
    }
}

#Preview {
    AddPointsScreen()
}
