//
// Created by Katsu Matsuda on 2022/07/02.
//

import Foundation

enum Primitive {
    case empty
    case vStack
    case hStack
    case zStack
    case geometryReader((GeometryProxy) -> ViewGraphNode)
    case padding(Padding)
    case rectangle(Rectangle)
    case text(Text)
    case image(String)
}

extension Primitive {
    struct Rectangle {
        let color: Color
        let cornerRadius: CornerRadius
    }

    struct Text {
        let text: String
        let color: Color
        let fontSize: Double
        let fontWeight: FontWeight
        let alignment: TextAlignment
    }
}
