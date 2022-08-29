//
// Created by Katsu Matsuda on 2022/07/17.
//

import Foundation

class ViewGraphNodeEntity<C> where C: View {
    let primitive: Primitive
    var _size: Size
    var _subNodes: [ViewGraphNode] = []
    var view: C
    var viewProp: ViewProp

    var _currentFrame = Frame()

    var _needRebuild = false
    var _needLayout = false
    var viewUnitsCache: [ViewUnit]? = nil

    var viewGraphNodeManager: ViewGraphNodeManager? = nil

    init(primitive: Primitive, size: Size, subNodes: [ViewGraphNode], view: C, viewProp: ViewProp) {
        self.primitive = primitive
        self._size = size
        self._subNodes = subNodes
        self.view = view
        self.viewProp = viewProp
    }
}

protocol ViewGraphNode {
    var objectID: ObjectIdentifier { get }

    var needRebuild: Bool { get }

    var action: Action { get }

    var subNodes: [ViewGraphNode] { get }

    var size: Size { get }

    var currentFrame: Frame { get }

    var isVisible: Bool { get }

    func rebuildSubNodes()

    func generateViewUnits(in parentFrame: Frame) -> [ViewUnit]

    func markNeedRebuild()

    func markNeedLayout()

    func setViewAppear(_ manager: ViewGraphNodeManager)

    func setViewDisappear(_ manager: ViewGraphNodeManager)
}

extension ViewGraphNodeEntity: ViewGraphNode {
    var objectID: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    var needRebuild: Bool {
        _needRebuild
    }

    var action: Action {
        viewProp.action
    }

    var subNodes: [ViewGraphNode] {
        _subNodes
    }

    var size: Size {
        _size
    }

    var currentFrame: Frame {
        _currentFrame
    }
    var isVisible: Bool {
        switch primitive {
        case .text(let text):
            return text.color != .clear
        case .rectangle(let rect):
            return rect.color != .clear
        default:
            return false
        }
    }

    func rebuildSubNodes() {
        let newSubNode = view.body.generateViewGraph()
        replaceSubNodes(newSubNode)
    }

    func replaceSubNodes(_ newSubNode: ViewGraphNode) {
        guard let manager = viewGraphNodeManager else {
            fatalError("ViewGraphNodeManager is not set")
        }
        newSubNode.setViewAppear(manager)

        _subNodes.forEach { $0.setViewDisappear(manager) }
        _subNodes = [newSubNode]
    }


    func generateViewUnits(in parentFrame: Frame) -> [ViewUnit] {
        if _needRebuild {
            rebuildSubNodes()
            viewUnitsCache = nil
            _needRebuild = false
        }

        if _needLayout {
            viewUnitsCache = nil
            _needLayout = false
            for i in 0..<subNodes.count {
                subNodes[i].markNeedLayout()
            }
        }

        if let viewUnits = viewUnitsCache {
            return viewUnits
        }

        var frame = thisFrame(in: parentFrame)

        let viewUnits: [ViewUnit]

        switch primitive {
        case .empty:
            viewUnits = subNodes.flatMap { $0.generateViewUnits(in: frame) }

        case .vStack:
            viewUnits = generateVStackViewUnits(thisFrame: frame)

        case .hStack:
            viewUnits = generateHStackViewUnits(thisFrame: frame)

        case .zStack:
            viewUnits = subNodes.flatMap { $0.generateViewUnits(in: frame) }

        case .geometryReader(let subNodeGen):
            let geo = GeometryProxy(size: Size(width: frame.width, height: frame.height))
            replaceSubNodes(subNodeGen(geo))
            viewUnits = subNodes.flatMap { $0.generateViewUnits(in: frame) }

        case .padding(let padding):
            let contentFrame = Frame(
                x: frame.x + padding.left,
                y: frame.y + padding.top,
                width: frame.width - padding.left - padding.right,
                height: frame.height - padding.top - padding.bottom
            )
            viewUnits = subNodes.flatMap { $0.generateViewUnits(in: contentFrame) }

        case .text(let text):
            let _primitive: Primitive
            if viewProp.textProp.fitTextToParent {
                print(frame)
                let fontSize = text.preferredFontSize(in: Size(width: frame.width, height: frame.height))
                let textPrim = Primitive.Text(text: text.text, color: text.color, fontSize: fontSize, fontWeight: text.fontWeight, alignment: text.alignment)
                _primitive = .text(textPrim)

                let textSize = textPrim.size(constrainedWidth: frame.width, constrainedHeight: frame.height)
                print(textSize)
                frame = ViewGraphNodeEntity.childFrame(child: textSize, parent: parentFrame)
            } else {
                _primitive = primitive
            }

            viewUnits =
                subNodes.flatMap { $0.generateViewUnits(in: frame) } +
                [ViewUnit(primitive: _primitive, frame: frame)]

        case .image(let _):
            viewUnits = [ViewUnit(primitive: primitive, frame: frame)]

        default:
            viewUnits =
                subNodes.flatMap { $0.generateViewUnits(in: frame) } +
                [ViewUnit(primitive: primitive, frame: frame)]
        }

        _currentFrame = frame

        viewUnitsCache = viewUnits

        return viewUnits
    }

    func markNeedRebuild() {
        _needRebuild = true
    }

    func markNeedLayout() {
        _needLayout = true
    }

    func setViewAppear(_ manager: ViewGraphNodeManager) {
        viewGraphNodeManager = manager
        if manager.register(id: viewProp.id) {
            action.onAppear?()
        }

        subNodes.forEach { $0.setViewAppear(manager) }
    }

    func setViewDisappear(_ manager: ViewGraphNodeManager) {
        if manager.unregister(id: viewProp.id) {
            action.onDisappear?()
        }

        subNodes.forEach { $0.setViewDisappear(manager) }
    }
}

extension ViewGraphNodeEntity {
    func thisFrame(in parentFrame: Frame) -> Frame {
        Self.childFrame(child: size, parent: parentFrame)
    }

    static func childFrame(child childSize: Size, parent parentFrame: Frame) -> Frame {
        let resolvedSize = Size(
            width: childSize.width == .infinity ? parentFrame.width : childSize.width,
            height: childSize.height == .infinity ? parentFrame.height : childSize.height
        )

        return Frame(
            x: parentFrame.x + parentFrame.width / 2 - resolvedSize.width / 2,
            y: parentFrame.y + parentFrame.height / 2 - resolvedSize.height / 2,
            width: resolvedSize.width,
            height: resolvedSize.height
        )
    }

    func generateVStackViewUnits(thisFrame: Frame) -> [ViewUnit] {
        let flexViewCount = subNodes.reduce(0) { $0 + ($1.size.height == .infinity ? 1 : 0) }
        let reservedHeight = subNodes.reduce(0) { $0 + ($1.size.height == .infinity ? 0 : $1.size.height) }
        let flexViewHeight = (thisFrame.height - reservedHeight) / Double(flexViewCount)

        var viewUnits = [ViewUnit]()
        var y = thisFrame.y
        for subNode in subNodes {
            let height = subNode.size.height == .infinity ? flexViewHeight : subNode.size.height
            viewUnits += subNode.generateViewUnits(in: Frame(x: thisFrame.x, y: y, width: thisFrame.width, height: height))
            y += height
        }

        return viewUnits
    }

    func generateHStackViewUnits(thisFrame: Frame) -> [ViewUnit] {
        let flexViewCount = subNodes.reduce(0) { $0 + ($1.size.width == .infinity ? 1 : 0) }
        let reservedWidth = subNodes.reduce(0) { $0 + ($1.size.width == .infinity ? 0 : $1.size.width) }
        let flexViewWidth = (thisFrame.width - reservedWidth) / Double(flexViewCount)

        var viewUnits = [ViewUnit]()
        var x = thisFrame.x
        for subNode in subNodes {
            let width = subNode.size.width == .infinity ? flexViewWidth : subNode.size.width
            viewUnits += subNode.generateViewUnits(in: Frame(x: x, y: thisFrame.y, width: width, height: thisFrame.height))
            x += width
        }

        return viewUnits
    }
}
