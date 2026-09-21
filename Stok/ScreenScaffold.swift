import SwiftUI

/// Strip (32) + action (14 + 50) + gap (12) + nav (62). The safe-area insets
/// cancel out: the frame ignores them and pads them back on.
private let chromeHeight: CGFloat = 170

/// Every artboard is the same three-part frame: a fixed strip on top, a body
/// that takes the remaining height, then the action and the nav pinned to the
/// bottom. The canvas draws that body at exactly 844pt; on a real device the
/// safe areas eat into it, so the body scrolls rather than clips.
struct ScreenScaffold<Strip: View, Action: View, Content: View>: View {
    @Binding var selection: AppSection
    let strip: Strip
    let action: Action
    @ViewBuilder let content: () -> Content

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                strip
                    .padding(.top, proxy.safeAreaInsets.top)
                    .background(Theme.barBg)

                ScrollView(.vertical) {
                    content()
                        .screenBody()
                        .padding(.bottom, 4)
                        // Let the body fill the gap when it is shorter than the
                        // viewport, so a screen can push a card to the bottom
                        // the way the canvas does.
                        .frame(
                            minHeight: max(0, proxy.size.height - chromeHeight),
                            alignment: .top
                        )
                }
                .scrollIndicators(.hidden)
                .scrollBounceBehavior(.basedOnSize)

                action

                Color.clear.frame(height: 12)

                BottomNav(selection: $selection)
                    .padding(.bottom, proxy.safeAreaInsets.bottom)
                    .background(Theme.barBg)
            }
            .background(Theme.bg)
            .ignoresSafeArea()
        }
        .preferredColorScheme(.dark)
    }
}
