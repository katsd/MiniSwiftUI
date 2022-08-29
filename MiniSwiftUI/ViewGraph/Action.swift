//
// Created by Katsu Matsuda on 2022/07/18.
//

import Foundation

/*
enum Action {
    case none
    case onAppear(() -> ())
    case onHover((Bool) -> ())
}
*/

struct Action {
    private (set) var onAppear: (() -> ())?
    private (set) var onDisappear: (() -> ())?
    private (set) var onHover: ((Bool) -> ())?
    private (set) var onClick: (() -> ())?

    init() {
        onAppear = nil
        onDisappear = nil
        onHover = nil
        onClick = nil
    }

    func with(onAppear: @escaping () -> ()) -> Action {
        var newAction = self
        newAction.onAppear = onAppear
        return newAction
    }

    func with(onDisappear: @escaping () -> ()) -> Action {
        var newAction = self
        newAction.onDisappear = onDisappear
        return newAction
    }

    func with(onHover: @escaping (Bool) -> ()) -> Action {
        var newAction = self
        newAction.onHover = onHover
        return newAction
    }

    func with(onClick: @escaping () -> ()) -> Action {
        var newAction = self
        newAction.onClick = onClick
        return newAction
    }

    var includeMouseEventAction: Bool {
        onHover != nil || onClick != nil
    }
}
