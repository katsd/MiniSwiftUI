//
// Created by Katsu Matsuda on 2022/07/21.
//

import Foundation

struct Frame {
    let x: Double
    let y: Double
    let width: Double
    let height: Double

    init() {
        x = 0
        y = 0
        width = 0
        height = 0
    }

    init(x: Double, y: Double, width: Double, height: Double) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
}

extension Frame {
    func including(_ point: Point) -> Bool {
        x <= point.x && point.x <= x + width && y <= point.y && point.y <= y + height
    }
}
