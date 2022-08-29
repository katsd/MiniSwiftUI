//
// Created by Katsu Matsuda on 2022/07/21.
//

import Foundation

struct HStack: View {
    let view: TupleView

    init(@ViewBuilder view: () -> TupleView) {
        self.view = view()
    }

    var body: Never {
        fatalError("HStack")
    }
}
