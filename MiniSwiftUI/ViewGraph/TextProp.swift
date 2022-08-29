//
// Created by Katsu Matsuda on 2022/07/25.
//

import Foundation

struct TextProp {
    private (set) var fontSize: Double
    private (set) var fontWeight: FontWeight
    private (set) var alignment: TextAlignment
    private (set) var fitTextToParent: Bool

    init(fontSize: Double = 15, fontWeight: FontWeight = .regular, alignment: TextAlignment = .center, fitTextToParent: Bool = false) {
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.alignment = alignment
        self.fitTextToParent = fitTextToParent
    }

    func with(fontSize: Double) -> TextProp {
        var newProp = self
        newProp.fontSize = fontSize
        return newProp
    }

    func with(fontWeight: FontWeight) -> TextProp {
        var newProp = self
        newProp.fontWeight = fontWeight
        return newProp
    }

    func with(alignment: TextAlignment) -> TextProp {
        var newProp = self
        newProp.alignment = alignment
        return newProp
    }

    func with(fitTextToParent: Bool) -> TextProp {
        var newProp = self
        newProp.fitTextToParent = fitTextToParent
        return newProp
    }
}
