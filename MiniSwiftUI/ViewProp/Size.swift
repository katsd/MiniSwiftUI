//
// Created by Katsu Matsuda on 2022/07/23.
//

import Foundation

struct Size {
    let width: Double
    let height: Double

    static var infinity: Size {
        .init(width: .infinity, height: .infinity)
    }
}
