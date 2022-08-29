//
// Created by Katsu Matsuda on 2022/07/24.
//

import Foundation

extension ViewGraphNode {
    func eval(mouseInfo: MouseInfo) {
        detectMouseEvent(mouseInfo: mouseInfo)
    }

    func detectMouseEvent(mouseInfo: MouseInfo) {
        //print(mouseInfo.dragStartedPosition, mouseInfo.mouseUp)

        let nodesIncludingMouse = detectMouseEvent(mouseInfo: mouseInfo, inheritedNode: self)

        // Hover
        if nodesIncludingMouse.nodeIncludingCurrentPos == nil {
            if let nodeIncludingPreviousPos = nodesIncludingMouse.nodeIncludingPreviousPos {
                nodeIncludingPreviousPos.action.onHover?(false)
            }
        }
        if nodesIncludingMouse.nodeIncludingPreviousPos == nil {
            if let nodeIncludingCurrentPos = nodesIncludingMouse.nodeIncludingCurrentPos {
                nodeIncludingCurrentPos.action.onHover?(true)
            }
        }
        if let nodeIncludingPreviousPos = nodesIncludingMouse.nodeIncludingPreviousPos,
           let nodeIncludingCurrentPos = nodesIncludingMouse.nodeIncludingCurrentPos {
            if nodeIncludingPreviousPos.objectID != nodeIncludingCurrentPos.objectID {
                nodeIncludingPreviousPos.action.onHover?(false)
                nodeIncludingCurrentPos.action.onHover?(true)
            }
        }

        // Click
        if let nodeIncludingDragStartedPos = nodesIncludingMouse.nodeIncludingDragStartedPos,
           let nodeIncludingCurrentPos = nodesIncludingMouse.nodeIncludingCurrentPos {
            if nodeIncludingDragStartedPos.objectID == nodeIncludingCurrentPos.objectID && mouseInfo.mouseUp {
                nodeIncludingDragStartedPos.action.onClick?()
            }
        }
    }

    fileprivate func detectMouseEvent(mouseInfo: MouseInfo, inheritedNode: ViewGraphNode) -> NodesIncludingMouse {
        let node: ViewGraphNode
        if action.includeMouseEventAction {
            node = self
        } else {
            node = inheritedNode
        }

        var res = NodesIncludingMouse(nodeIncludingCurrentPos: nil, nodeIncludingPreviousPos: nil, nodeIncludingDragStartedPos: nil)

        if subNodes.isEmpty {
            if !isVisible {
                return res
            }

            if currentFrame.including(mouseInfo.position) {
                res = res.with(nodeIncludingCurrentPos: node)
            }

            if currentFrame.including(mouseInfo.previousPosition) {
                res = res.with(nodeIncludingPreviousPos: node)
            }

            if let dragStartedPos = mouseInfo.dragStartedPosition, currentFrame.including(dragStartedPos) {
                res = res.with(nodeIncludingDragStartedPos: node)
            }

            return res
        }

        for i in (0..<subNodes.count).reversed() {
            var descend = false
            if let dragStartedPos = mouseInfo.dragStartedPosition {
                if subNodes[i].currentFrame.including(dragStartedPos) {
                    descend = true
                }
            }

            if subNodes[i].currentFrame.including(mouseInfo.position) ||
                   subNodes[i].currentFrame.including(mouseInfo.previousPosition) {
                descend = true
            }

            if descend {
                let r = subNodes[i].detectMouseEvent(mouseInfo: mouseInfo, inheritedNode: node)

                if res.nodeIncludingCurrentPos == nil {
                    if let n = r.nodeIncludingCurrentPos {
                        res = res.with(nodeIncludingCurrentPos: n)
                    }
                }

                if res.nodeIncludingPreviousPos == nil {
                    if let n = r.nodeIncludingPreviousPos {
                        res = res.with(nodeIncludingPreviousPos: n)
                    }
                }

                if res.nodeIncludingDragStartedPos == nil {
                    if let n = r.nodeIncludingDragStartedPos {
                        res = res.with(nodeIncludingDragStartedPos: n)
                    }
                }
            }
        }

        return res
    }

}

fileprivate struct NodesIncludingMouse {
    let nodeIncludingCurrentPos: ViewGraphNode?
    let nodeIncludingPreviousPos: ViewGraphNode?
    let nodeIncludingDragStartedPos: ViewGraphNode?

    func with(nodeIncludingCurrentPos: ViewGraphNode) -> NodesIncludingMouse {
        .init(nodeIncludingCurrentPos: nodeIncludingCurrentPos, nodeIncludingPreviousPos: nodeIncludingPreviousPos, nodeIncludingDragStartedPos: nodeIncludingDragStartedPos)
    }

    func with(nodeIncludingPreviousPos: ViewGraphNode) -> NodesIncludingMouse {
        .init(nodeIncludingCurrentPos: nodeIncludingCurrentPos, nodeIncludingPreviousPos: nodeIncludingPreviousPos, nodeIncludingDragStartedPos: nodeIncludingDragStartedPos)
    }

    func with(nodeIncludingDragStartedPos: ViewGraphNode) -> NodesIncludingMouse {
        .init(nodeIncludingCurrentPos: nodeIncludingCurrentPos, nodeIncludingPreviousPos: nodeIncludingPreviousPos, nodeIncludingDragStartedPos: nodeIncludingDragStartedPos)
    }
}