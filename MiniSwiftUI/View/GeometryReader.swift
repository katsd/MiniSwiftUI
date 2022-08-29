//
// Created by Katsu Matsuda on 2022/07/25.
//

import Foundation

struct GeometryReader<Content>: View where Content: View {

    let content: (GeometryProxy) -> Content

    init(@ViewBuilder content: @escaping (GeometryProxy) -> Content) {
        self.content = content
    }

    var body: Never {
        fatalError("GeometryReader")
    }
}
