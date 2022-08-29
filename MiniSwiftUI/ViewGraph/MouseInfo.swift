//
// Created by Katsu Matsuda on 2022/07/24.
//

import Foundation

struct MouseInfo {
    var previousPosition: Point
    var position: Point
    var dragStartedPosition: Point?
    var isClicked: Bool
    var mouseUp: Bool

    init() {
        previousPosition = .zero
        position = .zero
        dragStartedPosition = nil
        isClicked = false
        mouseUp = false
    }
}