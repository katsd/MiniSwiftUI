//
// Created by Katsu Matsuda on 2022/07/23.
//

import Foundation

struct Text<T>: View where T: StringProtocol {
    let text: T

    init(_ text: T) {
        self.text = text
    }

    var body: Never {
        fatalError("Text")
    }
}
