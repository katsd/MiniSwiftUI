//
// Created by Katsu Matsuda on 2022/07/23.
//

import Foundation

struct Group: View {
    let view: TupleView

    init(@ViewBuilder view: () -> TupleView) {
        self.view = view()
    }

    var body: TupleView {
        fatalError("Group")
    }
}
