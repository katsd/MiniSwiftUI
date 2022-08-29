//
// Created by Katsu Matsuda on 2022/07/25.
//

import Foundation

struct Button<Label>: View where Label: View {
    let action: () -> ()
    let label: Label

    init(action: @escaping () -> (), @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()

        dump(self.label)
    }

    var body: some View {
        label
            .onClick(action)
    }
}