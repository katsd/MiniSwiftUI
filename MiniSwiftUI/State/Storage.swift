//
// Created by Katsu Matsuda on 2022/07/18.
//

import Foundation

class Storage<Value> {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }
}