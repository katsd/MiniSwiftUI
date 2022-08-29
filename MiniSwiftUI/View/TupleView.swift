//
// Created by Katsu Matsuda on 2022/07/21.
//

import Foundation

struct TupleView: View {
    let view: Any

    var conditionID = ""

    init() {
        view = TupleView0()
    }

    init<C0>(_ c0: C0) where C0: View {
        view = TupleView1(c0)
    }

    init<C0, C1>(_ c0: C0, _ c1: C1) where C0: View, C1: View {
        view = TupleView2(c0, c1)
    }

    init<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) where C0: View, C1: View, C2: View {
        view = TupleView2(c0, TupleView2(c1, c2))
    }

    init<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) where C0: View, C1: View, C2: View, C3: View {
        view = TupleView2(c0, TupleView2(c1, TupleView2(c2, c3)))
    }

    init<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) where C0: View, C1: View, C2: View, C3: View, C4: View {
        view = TupleView2(c0, TupleView2(c1, TupleView2(c2, TupleView2(c3, c4))))
    }

    init<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View {
        view = TupleView2(c0, TupleView2(c1, TupleView2(c2, TupleView2(c3, TupleView2(c4, c5)))))
    }

    init<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View {
        view = TupleView2(c0, TupleView2(c1, TupleView2(c2, TupleView2(c3, TupleView2(c4, TupleView2(c5, c6))))))
    }

    init<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View {
        view = TupleView2(c0, TupleView2(c1, TupleView2(c2, TupleView2(c3, TupleView2(c4, TupleView2(c5, TupleView2(c6, c7)))))))
    }

    init<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View {
        view = TupleView2(c0, TupleView2(c1, TupleView2(c2, TupleView2(c3, TupleView2(c4, TupleView2(c5, TupleView2(c6, TupleView2(c7, c8))))))))
    }

    init<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View {
        view = TupleView2(c0, TupleView2(c1, TupleView2(c2, TupleView2(c3, TupleView2(c4, TupleView2(c5, TupleView2(c6, TupleView2(c7, TupleView2(c8, c9)))))))))
    }

    var body: Never {
        fatalError("TupleView")
    }
}

struct TupleView0: View {
    init() {
    }

    var body: Never {
        fatalError("TupleView0")
    }
}

struct TupleView1<C0>: View where C0: View {
    let c0: C0

    init(_ c0: C0) {
        self.c0 = c0
    }

    var body: Never {
        fatalError("TupleView1")
    }
}

struct TupleView2<C0, C1>: View where C0: View, C1: View {
    let c0: C0
    let c1: C1

    init(_ c0: C0, _ c1: C1) {
        self.c0 = c0
        self.c1 = c1
    }

    var body: Never {
        fatalError("TupleView2")
    }

}
