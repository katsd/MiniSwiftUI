//
// Created by Katsu Matsuda on 2022/07/25.
//

import Foundation

extension Color: View {
    var body: some View {
        Rectangle()
            .foregroundColor(self)
    }
}
