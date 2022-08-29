//
// Created by Katsu Matsuda on 2022/07/24.
//

import Foundation

struct ZStack: View {
    let view: TupleView

    init(@ViewBuilder view: () -> TupleView) {
        self.view = view()
    }

    var body: Never {
        fatalError("ZStack")
    }
}
