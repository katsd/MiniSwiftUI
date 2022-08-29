//
// Created by Katsu Matsuda on 2022/06/18.
//

import Cocoa

class Renderer: NSView {

    static let fps = 60.0

    let viewGraphNodeManager = ViewGraphNodeManager()

    var viewGraph: ViewGraphNode

    var previousRect: NSRect = .zero

    var mouseInfo = MouseInfo()

    init<C>(content: C, frame: NSRect) where C: View {
        viewGraph = content.generateViewGraph()
        super.init(frame: NSRect())

        //dump(viewGraph)

        viewGraph.setViewAppear(viewGraphNodeManager)

        Timer.scheduledTimer(withTimeInterval: 1.0 / Renderer.fps, repeats: true) { _ in
            self.setMousePosition()
            self.viewGraph.eval(mouseInfo: self.mouseInfo)
            self.setNeedsDisplay(NSRect(x: 0, y: 0, width: Double.infinity, height: Double.infinity))

            if self.mouseInfo.mouseUp {
                self.mouseInfo.mouseUp = false
                self.mouseInfo.dragStartedPosition = nil
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)

        mouseInfo.isClicked = true
        mouseInfo.dragStartedPosition = event.locationInWindow.toPoint(in: frame)
    }

    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)

        mouseInfo.isClicked = false
        mouseInfo.mouseUp = true
    }

    func setMousePosition() {
        mouseInfo.previousPosition = mouseInfo.position
        if let pos = window?.mouseLocationOutsideOfEventStream {
            mouseInfo.position = pos.toPoint(in: frame)
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        let context = NSGraphicsContext.current!.cgContext

        if previousRect != dirtyRect {
            viewGraph.markNeedLayout()
        }
        previousRect = dirtyRect

        let viewUnits = viewGraph.generateViewUnits(in: dirtyRect.toFrame(in: dirtyRect))

        for viewUnit in viewUnits {
            switch viewUnit.primitive {
            case .rectangle(let rectangle):
                if rectangle.cornerRadius.isAngular {
                    context.setFillColor(rectangle.color.cgColor)
                    context.addRect(viewUnit.cgRect(in: dirtyRect))
                    context.fillPath()
                } else {
                    //TODO:
                    let cornerRadius = rectangle.cornerRadius.leftTop
                    let path = NSBezierPath(roundedRect: viewUnit.cgRect(in: dirtyRect), xRadius: cornerRadius, yRadius: cornerRadius)
                    NSColor(cgColor: rectangle.color.cgColor)?.setFill()
                    path.fill()
                }

            case .text(let text):
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                text.attributedString.draw(in: viewUnit.cgRect(in: dirtyRect))

            case .image(let name):
                let image = NSImage(named: name)!
                let frame: Frame
                if image.size.width / image.size.height < viewUnit.frame.width / viewUnit.frame.height {
                    let width = viewUnit.frame.height * image.size.width / image.size.height
                    frame = .init(x: viewUnit.frame.x + viewUnit.frame.width / 2 - width / 2, y: viewUnit.frame.y, width: width, height: viewUnit.frame.height)
                } else {
                    let height = viewUnit.frame.width * image.size.height / image.size.width
                    frame = .init(x: viewUnit.frame.x, y: viewUnit.frame.y + viewUnit.frame.height / 2 - height / 2, width: viewUnit.frame.width, height: height)
                }

                context.draw(image.toCGImage, in: frame.cgRect(in: dirtyRect))

            default:
                break
            }
        }

    }
}

extension NSImage {
    var toCGImage: CGImage {
        var imageRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let image = cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
            abort()
        }
        return image
    }
}

extension Frame {
    func cgRect(in parentRect: CGRect) -> CGRect {
        CGRect(x: x, y: parentRect.height - y - height, width: width, height: height)
    }
}