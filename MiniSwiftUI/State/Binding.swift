//
// Created by Katsu Matsuda on 2022/07/19.
//

import Foundation

@propertyWrapper
struct Binding<Value> {
    let get: () -> Value
    let set: (Value) -> ()

    init(get: @escaping () -> Value, set: @escaping (Value) -> ()) {
        self.get = get
        self.set = set
    }

    var wrappedValue: Value {
        get {
            get()
        }
        nonmutating set {
            set(newValue)
        }
    }

    var projectedValue: Binding<Value> {
        self
    }

    static func constant(_ value: Value) -> Binding<Value> {
        .init(get: { value }, set: { _ in })
    }
}
