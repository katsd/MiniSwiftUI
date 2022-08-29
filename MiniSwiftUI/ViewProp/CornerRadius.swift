//
// Created by Katsu Matsuda on 2022/07/23.
//

import Foundation

struct CornerRadius {
    let leftTop: Double
    let rightTop: Double
    let rightBottom: Double
    let leftBottom: Double

    init(_ leftTop: Double, _ rightTop: Double, _ rightBottom: Double, _ leftBottom: Double) {
        self.leftTop = leftTop
        self.rightTop = rightTop
        self.rightBottom = rightBottom
        self.leftBottom = leftBottom
    }

    init(_ radius: Double) {
        self.init(radius, radius, radius, radius)
    }

    init() {
        self.init(0)
    }

    var isAngular: Bool {
        leftTop == 0 && rightTop == 0 && rightBottom == 0 && leftBottom == 0
    }
}