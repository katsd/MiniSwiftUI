//
// Created by Katsu Matsuda on 2022/07/21.
//

import Foundation

extension View {
    func overlay<Content>(_ view: Content) -> some View where Content: View {
        ModifierOverlay(content: self, overlayContent: view)
    }

    func background<Content>(_ view: Content) -> some View where Content: View {
        ModifierBackground(content: self, backgroundContent: view)
    }

    func frame(width: Double = .infinity, height: Double = .infinity) -> some View {
        ModifierFrame(size: Size(width: width, height: height), content: self)
    }

    func foregroundColor(_ color: Color) -> some View {
        ModifierForegroundColor(color: color, content: self)
    }

    func cornerRadius(_ cornerRadius: Double) -> some View {
        ModifierCornerRadius(cornerRadius: CornerRadius(cornerRadius), content: self)
    }

    func fontSize(_ size: Double) -> some View {
        ModifierFontSize(fontSize: size, content: self)
    }

    func fontWeight(_ weight: FontWeight) -> some View {
        ModifierFontWeight(fontWeight: weight, content: self)
    }

    func textAlignment(_ alignment: TextAlignment) -> some View {
        ModifierTextAlignment(alignment: alignment, content: self)
    }

    func fitToParent(_ value: Bool = true) -> some View {
        ModifierFitTextToParent(fitTextToParent: value, content: self)
    }

    func padding() -> some View {
        padding(10)
    }

    func padding(_ length: Double) -> some View {
        padding(left: length, top: length, right: length, bottom: length)
    }

    func padding(horizontal: Double, vertical: Double) -> some View {
        padding(left: horizontal, top: vertical, right: horizontal, bottom: vertical)
    }

    func padding(left: Double, top: Double, right: Double, bottom: Double) -> some View {
        ModifierPadding(padding: .init(left: left, top: top, right: right, bottom: bottom), content: self)
    }

    func cornerRadius(_ cornerRadius: CornerRadius) -> some View {
        ModifierCornerRadius(cornerRadius: cornerRadius, content: self)
    }

    func onAppear(_ action: @escaping () -> ()) -> some View {
        ModifierOnAppear(action: action, content: self)
    }

    func onDisappear(_ action: @escaping () -> ()) -> some View {
        ModifierOnDisappear(action: action, content: self)
    }

    func onHover(_ action: @escaping (Bool) -> ()) -> some View {
        ModifierOnHover(action: action, content: self)
    }

    func onClick(_ action: @escaping () -> ()) -> some View {
        ModifierOnClick(action: action, content: self)
    }
}
