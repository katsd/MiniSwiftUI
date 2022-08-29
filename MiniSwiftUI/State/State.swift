//
// Created by Katsu Matsuda on 2022/07/02.
//

import Foundation

@propertyWrapper
struct State<Value> {
    var storage: Storage<Value>

    var wrappedValue: Value {
        get {
            storage.value
        }
        nonmutating set {
            storage.value = newValue
            rebuildView()
        }
    }

    var projectedValue: Binding<Value> {
        .init(get: { wrappedValue }, set: { wrappedValue = $0 })
    }

    var rebuildView: () -> () = {
        print("!!! Not modified !!!")
    }

    init(wrappedValue value: Value) {
        self.storage = Storage(value)
    }

    func setViewGraph() {
        //viewGraph = ViewGraphNode(primitive: .empty, frame: .init(), subNodes: [])
    }
}

protocol IsState {
}

extension State: IsState {

}
