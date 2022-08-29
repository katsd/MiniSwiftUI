//
// Created by Katsu Matsuda on 2022/07/24.
//

import Foundation

struct ViewProp {
    private (set) var id: String
    private (set) var reservedSize: Size
    private (set) var color: Color?
    private (set) var cornerRadius: CornerRadius?
    private (set) var action: Action
    private (set) var textProp: TextProp

    init(id: String, reservedSize: Size = .infinity, color: Color? = nil, cornerRadius: CornerRadius? = nil, action: Action = .init(), textProp: TextProp = .init()) {
        self.id = id
        self.reservedSize = reservedSize
        self.color = color
        self.cornerRadius = cornerRadius
        self.action = action
        self.textProp = textProp
    }

    func withNextID() -> ViewProp {
        var newProp = self
        newProp.id += "_"
        return newProp
    }

    func withNextID(_ idx: Int) -> ViewProp {
        var newProp = self
        newProp.id += "\(idx)_"
        return newProp
    }

    func withNextID(_ str: String) -> ViewProp {
        var newProp = self
        newProp.id += str + "_"
        return newProp
    }

    func with(reservedSize: Size) -> ViewProp {
        var newProp = self
        newProp.reservedSize = reservedSize
        return newProp
    }

    func with(color: Color?) -> ViewProp {
        var newProp = self
        newProp.color = color
        return newProp
    }

    func with(cornerRadius: CornerRadius?) -> ViewProp {
        var newProp = self
        newProp.cornerRadius = cornerRadius
        return newProp
    }

    func with(action: Action) -> ViewProp {
        var newProp = self
        newProp.action = action
        return newProp
    }

    func with(textProp: TextProp) -> ViewProp {
        var newProp = self
        newProp.textProp = textProp
        return newProp
    }
}
