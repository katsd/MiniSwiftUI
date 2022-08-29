//
// Created by Katsu Matsuda on 2022/07/18.
//

import Foundation

struct ViewUnit {
    let primitive: Primitive
    let frame: Frame

    func cgRect(in parentRect: CGRect) -> CGRect {
        CGRect(x: frame.x, y: parentRect.height - frame.y - frame.height, width: frame.width, height: frame.height)
    }
}
