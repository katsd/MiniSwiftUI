//
// Created by Katsu Matsuda on 2022/07/21.
//

import Cocoa

extension Primitive.Text {
    func size(constrainedWidth: Double = CGFloat.greatestFiniteMagnitude, constrainedHeight: Double = CGFloat.greatestFiniteMagnitude) -> Size {
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)

        let size = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRange(location: 0, length: text.count), nil, CGSize(width: constrainedWidth, height: constrainedHeight), nil)

        return Size(width: size.width, height: size.height)
    }

    func preferredFontSize(in reservedSize: Size) -> Double {
        let textFrameSize = size(constrainedWidth: .infinity, constrainedHeight: .infinity)
        return fontSize * min(reservedSize.width / textFrameSize.width, reservedSize.height / textFrameSize.height)
    }
}
