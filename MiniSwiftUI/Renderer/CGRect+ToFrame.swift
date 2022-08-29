//
// Created by Katsu Matsuda on 2022/07/24.
//

import Foundation

extension CGRect {
    func toFrame(in parentRect: CGRect) -> Frame {
        .init(x: minX, y: parentRect.height - maxY, width: width, height: height)
    }
}