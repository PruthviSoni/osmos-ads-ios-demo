import SwiftUI

struct AdVisibilityModifier: ViewModifier {

    let threshold: CGFloat
    let containerFrame: CGRect
    let onVisible: () -> Void

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            checkVisibility(
                                geometry.frame(in: .global)
                            )
                        }
                        .onChange(
                            of: geometry.frame(in: .global)
                        ) { frame in
                            checkVisibility(frame)
                        }
                }
            )
    }

    private func checkVisibility(_ adFrame: CGRect) {
        guard
            adFrame.width > 0,
            adFrame.height > 0,
            containerFrame.width > 0,
            containerFrame.height > 0
        else {
            return
        }

        let intersection = adFrame.intersection(containerFrame)

        let visibleWidth = max(0, intersection.width)
        let visibleHeight = max(0, intersection.height)

        let visibleArea = visibleWidth * visibleHeight
        let adArea = adFrame.width * adFrame.height

        guard adArea > 0 else {
            return
        }

        let visibility = visibleArea / adArea

        if visibility >= threshold {
            onVisible()
        }
    }
}

extension View {

    func adVisibility(
        threshold: CGFloat,
        containerFrame: CGRect,
        onVisible: @escaping () -> Void
    ) -> some View {
        modifier(
            AdVisibilityModifier(
                threshold: threshold,
                containerFrame: containerFrame,
                onVisible: onVisible
            )
        )
    }
}
