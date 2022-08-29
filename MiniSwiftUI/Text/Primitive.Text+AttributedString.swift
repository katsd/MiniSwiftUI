//
// Created by Katsu Matsuda on 2022/07/25.
//

import Cocoa

extension Primitive.Text {
    var attributedString: NSAttributedString {
        NSAttributedString(
            string: text,
            attributes: [
                .font: NSFont.systemFont(ofSize: fontSize, weight: nsFontWeight()),
                .foregroundColor: NSColor(cgColor: color.cgColor) ?? .systemPink,
                .paragraphStyle: paragraphStyle()
            ]
        )
    }

    fileprivate func paragraphStyle() -> NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()

        switch alignment {
        case .left: style.alignment = .left
        case .center: style.alignment = .center
        case .right: style.alignment = .right
        }

        return style
    }

    fileprivate func nsFontWeight() -> NSFont.Weight {
        switch fontWeight {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        }
    }
}