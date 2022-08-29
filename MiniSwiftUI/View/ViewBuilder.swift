//
// Created by Katsu Matsuda on 2022/07/22.
//

import Foundation

@resultBuilder
public struct ViewBuilder {
    static func buildOptional(_ component: TupleView?) -> TupleView {
        component ?? TupleView()
    }

    static func buildEither(first component: TupleView) -> TupleView {
        var c = component
        c.conditionID += "f"
        return c
    }

    static func buildEither(second component: TupleView) -> TupleView {
        var c = component
        c.conditionID += "s"
        return c
    }

    static func buildBlock() -> TupleView {
        TupleView()
    }

    static func buildBlock<C0>(_ c0: C0) -> TupleView where C0: View {
        TupleView(c0)
    }

    static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleView where C0: View, C1: View {
        TupleView(c0, c1)
    }

    static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleView where C0: View, C1: View, C2: View {
        TupleView(c0, c1, c2)
    }

    static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleView where C0: View, C1: View, C2: View, C3: View {
        TupleView(c0, c1, c2, c3)
    }

    static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleView where C0: View, C1: View, C2: View, C3: View, C4: View {
        TupleView(c0, c1, c2, c3, c4)
    }

    static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleView where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View {
        TupleView(c0, c1, c2, c3, c4, c5)
    }

    static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleView where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View {
        TupleView(c0, c1, c2, c3, c4, c5, c6)
    }

    static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleView where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View {
        TupleView(c0, c1, c2, c3, c4, c5, c6, c7)
    }

    static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleView where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View {
        TupleView(c0, c1, c2, c3, c4, c5, c6, c7, c8)
    }

    static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleView where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View {
        TupleView(c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)
    }
}
