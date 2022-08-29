//
// Created by Katsu Matsuda on 2022/07/17.
//

import Foundation
import Runtime

protocol SystemViewGraphGen {
    func generateSystemViewGraph(prop: ViewProp) -> ViewGraphNode
}

protocol SystemTupleViewGraphGen {
    func subViewCount() -> Int
    func generateSystemGroupViewGraph(prop: ViewProp) -> [ViewGraphNode]
}

protocol ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode
}

extension View {
    func generateViewGraph() -> ViewGraphNode {
        generateViewGraph(
            prop:
            ViewProp(
                id: "_",
                reservedSize: .infinity,
                color: nil,
                cornerRadius: nil
            )
        )
    }

    fileprivate func generateViewGraph(prop: ViewProp) -> ViewGraphNode {
        if let v = self as? SystemViewGraphGen {
            return v.generateSystemViewGraph(prop: prop)
        }
        if let v = self as? ModifierViewGraphGen {
            return v.generateModifierViewGraph(prop: prop)
        }
        if let _ = self as? SystemTupleViewGraphGen {
            let vStack = VStack(view: { self })
            return vStack.generateSystemViewGraph(prop: prop)
        }

        let node = ViewGraphNodeEntity(primitive: .empty, size: .infinity, subNodes: [], view: self, viewProp: prop)

        let rebuildView: () -> () = {
            //print("RENDER VIEW")
            node.markNeedRebuild()
        }

        let viewInfo = try! typeInfo(of: type(of: node.view))
        for prop in viewInfo.properties {
            var propVal = try! prop.get(from: node.view)
            if !(propVal is IsState) {
                continue
            }

            let stateInfo = try! typeInfo(of: type(of: propVal))
            let renderViewProp = try! stateInfo.property(named: "rebuildView")
            try! renderViewProp.set(value: rebuildView, on: &propVal)
            try! prop.set(value: propVal, on: &node.view)
        }

        let subNode = node.view.body.generateViewGraph(prop: prop.withNextID())
        node._subNodes = [subNode]
        node._size = subNode.size
        return node
    }
}

extension Text: SystemViewGraphGen {
    func generateSystemViewGraph(prop: ViewProp) -> ViewGraphNode {
        let prim: Primitive.Text
        let size: Size
        let color = prop.color ?? .black
        let textProp = prop.textProp

        prim = .init(text: String(text), color: color, fontSize: textProp.fontSize, fontWeight: textProp.fontWeight, alignment: textProp.alignment)

        if textProp.fitTextToParent {
            size = prop.reservedSize
        } else {
            size = prim.size(constrainedWidth: prop.reservedSize.width, constrainedHeight: prop.reservedSize.height)
        }

        return ViewGraphNodeEntity(primitive: .text(prim), size: size, subNodes: [], view: self, viewProp: prop)
    }
}

extension Rectangle: SystemViewGraphGen {
    func generateSystemViewGraph(prop: ViewProp) -> ViewGraphNode {
        let prim: Primitive
        let size = prop.reservedSize
        let color = prop.color ?? .black
        let cornerRadius = prop.cornerRadius ?? CornerRadius()

        prim = .rectangle(.init(color: color, cornerRadius: cornerRadius))
        return ViewGraphNodeEntity(primitive: prim, size: size, subNodes: [], view: self, viewProp: prop)
    }
}

extension Image: SystemViewGraphGen {
    func generateSystemViewGraph(prop: ViewProp) -> ViewGraphNode {
        ViewGraphNodeEntity(primitive: .image(name), size: prop.reservedSize, subNodes: [], view: self, viewProp: prop)
    }
}

extension ModifierOverlay: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        let contentNode = content.generateViewGraph(prop: prop.withNextID(0))
        let overlayNode = overlayContent.generateViewGraph(prop: prop.with(reservedSize: contentNode.size).withNextID(1))

        let size = Size(
            width: prop.reservedSize.width == .infinity ? contentNode.size.width : prop.reservedSize.width,
            height: prop.reservedSize.height == .infinity ? contentNode.size.height : prop.reservedSize.height
        )

        return ViewGraphNodeEntity(primitive: .zStack, size: size, subNodes: [contentNode, overlayNode], view: self, viewProp: prop)
    }
}

extension ModifierBackground: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        let contentNode = content.generateViewGraph(prop: prop.withNextID(0))
        let backgroundNode = backgroundContent.generateViewGraph(prop: prop.with(reservedSize: contentNode.size).withNextID(1))

        let size = Size(
            width: prop.reservedSize.width == .infinity ? contentNode.size.width : prop.reservedSize.width,
            height: prop.reservedSize.height == .infinity ? contentNode.size.height : prop.reservedSize.height
        )

        return ViewGraphNodeEntity(primitive: .zStack, size: size, subNodes: [backgroundNode, contentNode], view: self, viewProp: prop)
    }
}


extension ModifierFrame: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        body.generateViewGraph(
            prop: prop.with(
                reservedSize: Size(
                    width: size.width == .infinity ? prop.reservedSize.width : size.width,
                    height: size.height == .infinity ? prop.reservedSize.height : size.height
                )
            ).withNextID()
        )
    }
}

extension ModifierForegroundColor: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        body.generateViewGraph(prop: prop.with(color: color))
    }
}

extension ModifierCornerRadius: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        body.generateViewGraph(prop: prop.with(cornerRadius: cornerRadius))
    }
}

extension ModifierFontSize: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        body.generateViewGraph(prop: prop.with(textProp: prop.textProp.with(fontSize: fontSize)))
    }
}

extension ModifierFontWeight: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        body.generateViewGraph(prop: prop.with(textProp: prop.textProp.with(fontWeight: fontWeight)))
    }
}

extension ModifierTextAlignment: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        body.generateViewGraph(prop: prop.with(textProp: prop.textProp.with(alignment: alignment)))
    }
}

extension ModifierFitTextToParent: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        body.generateViewGraph(prop: prop.with(textProp: prop.textProp.with(fitTextToParent: fitTextToParent)))
    }
}

extension ModifierPadding: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        let subNode = body.generateViewGraph(prop: prop.withNextID())
        let size = Size(
            width: subNode.size.width + padding.left + padding.right,
            height: subNode.size.height + padding.top + padding.bottom
        )
        return ViewGraphNodeEntity(primitive: .padding(padding), size: size, subNodes: [subNode], view: self, viewProp: prop)
    }
}

extension ModifierOnAppear: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        body.generateViewGraph(prop: prop.with(action: prop.action.with(onAppear: action)))
    }
}

extension ModifierOnDisappear: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        body.generateViewGraph(prop: prop.with(action: prop.action.with(onDisappear: action)))
    }
}

extension ModifierOnHover: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        body.generateViewGraph(prop: prop.with(action: prop.action.with(onHover: action)))
    }
}

extension ModifierOnClick: ModifierViewGraphGen {
    func generateModifierViewGraph(prop: ViewProp) -> ViewGraphNode {
        body.generateViewGraph(prop: prop.with(action: prop.action.with(onClick: action)))
    }
}

extension GeometryReader: SystemViewGraphGen {
    func generateSystemViewGraph(prop: ViewProp) -> ViewGraphNode {
        let prim: Primitive = .geometryReader({ (geo: GeometryProxy) in content(geo).generateViewGraph(prop: prop.with(reservedSize: geo.size)) })
        return ViewGraphNodeEntity(primitive: prim, size: prop.reservedSize, subNodes: [], view: self, viewProp: prop)
    }
}

extension VStack: SystemViewGraphGen {
    func generateSystemViewGraph(prop: ViewProp) -> ViewGraphNode {
        let subNodes = view.generateSystemGroupViewGraph(prop: ViewProp(id: prop.withNextID().id))

        let childrenSize = Size(
            width: subNodes.map { $0.size.width }.max() ?? 0,
            height: subNodes.reduce(0) { $0 + $1.size.height }
        )

        let size = Size(
            width: prop.reservedSize.width == .infinity ? childrenSize.width : prop.reservedSize.width,
            height: prop.reservedSize.height == .infinity ? childrenSize.height : prop.reservedSize.height
        )

        return ViewGraphNodeEntity(primitive: .vStack, size: size, subNodes: subNodes, view: self, viewProp: prop)
    }
}

extension HStack: SystemViewGraphGen {
    func generateSystemViewGraph(prop: ViewProp) -> ViewGraphNode {
        let subNodes = view.generateSystemGroupViewGraph(prop: ViewProp(id: prop.withNextID().id))

        let childrenSize = Size(
            width: subNodes.reduce(0) { $0 + $1.size.width },
            height: subNodes.map { $0.size.height }.max() ?? 0
        )

        let size = Size(
            width: prop.reservedSize.width == .infinity ? childrenSize.width : prop.reservedSize.width,
            height: prop.reservedSize.height == .infinity ? childrenSize.height : prop.reservedSize.height
        )

        return ViewGraphNodeEntity(primitive: .hStack, size: size, subNodes: subNodes, view: self, viewProp: prop)
    }
}

extension ZStack: SystemViewGraphGen {
    func generateSystemViewGraph(prop: ViewProp) -> ViewGraphNode {
        let subNodes = view.generateSystemGroupViewGraph(prop: ViewProp(id: prop.withNextID().id))
        let childrenSize = Size(
            width: subNodes.map { $0.size.width }.max() ?? 0,
            height: subNodes.map { $0.size.height }.max() ?? 0
        )
        let size = Size(
            width: prop.reservedSize.width == .infinity ? childrenSize.width : prop.reservedSize.width,
            height: prop.reservedSize.height == .infinity ? childrenSize.height : prop.reservedSize.height
        )

        return ViewGraphNodeEntity(primitive: .zStack, size: size, subNodes: subNodes, view: self, viewProp: prop)
    }
}

extension Group: SystemViewGraphGen {
    func generateSystemViewGraph(prop: ViewProp) -> ViewGraphNode {
        let vStack = VStack(view: { view })
        return vStack.generateViewGraph(prop: prop)
    }
}

extension Group: SystemTupleViewGraphGen {
    func subViewCount() -> Int {
        view.subViewCount()
    }

    func generateSystemGroupViewGraph(prop: ViewProp) -> [ViewGraphNode] {
        view.generateSystemGroupViewGraph(prop: prop)
    }
}

extension TupleView: SystemTupleViewGraphGen {
    func subViewCount() -> Int {
        (view as? SystemTupleViewGraphGen)?.subViewCount() ?? 0
    }

    func generateSystemGroupViewGraph(prop: ViewProp) -> [ViewGraphNode] {
        (view as? SystemTupleViewGraphGen)?.generateSystemGroupViewGraph(prop: prop.withNextID(conditionID)) ?? []
    }
}

extension TupleView0: SystemTupleViewGraphGen {
    func subViewCount() -> Int {
        0
    }

    func generateSystemGroupViewGraph(prop: ViewProp) -> [ViewGraphNode] {
        []
    }
}

extension TupleView1: SystemTupleViewGraphGen {
    func subViewCount() -> Int {
        (c0 as? SystemTupleViewGraphGen)?.subViewCount() ?? 1
    }

    func generateSystemGroupViewGraph(prop: ViewProp) -> [ViewGraphNode] {
        if let v = c0 as? SystemTupleViewGraphGen {
            return v.generateSystemGroupViewGraph(prop: prop)
        }
        return [c0.generateViewGraph(prop: prop)]
    }
}

extension TupleView2: SystemTupleViewGraphGen {
    func subViewCount() -> Int {
        ((c0 as? SystemTupleViewGraphGen)?.subViewCount() ?? 1) +
            ((c1 as? SystemTupleViewGraphGen)?.subViewCount() ?? 1)
    }

    func generateSystemGroupViewGraph(prop: ViewProp) -> [ViewGraphNode] {
        var res = [ViewGraphNode]()

        res += (c0 as? SystemTupleViewGraphGen)?.generateSystemGroupViewGraph(prop: prop.withNextID(0)) ?? [c0.generateViewGraph(prop: prop.withNextID(0))]
        res += (c1 as? SystemTupleViewGraphGen)?.generateSystemGroupViewGraph(prop: prop.withNextID(1)) ?? [c1.generateViewGraph(prop: prop.withNextID(1))]

        return res
    }
}

extension EmptyView: SystemViewGraphGen {
    func generateSystemViewGraph(prop: ViewProp) -> ViewGraphNode {
        ViewGraphNodeEntity(primitive: .empty, size: prop.reservedSize, subNodes: [], view: self, viewProp: prop)
    }
}
