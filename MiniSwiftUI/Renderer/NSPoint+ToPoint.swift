//
// Created by Katsu Matsuda on 2022/07/24.
//

import Foundation

extension NSPoint {
    func toPoint(in frame: NSRect) -> Point {
        .init(x: x, y: frame.height - y)
    }
}