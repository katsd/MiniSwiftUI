//
// Created by Katsu Matsuda on 2022/07/21.
//

import Foundation

struct ModifierOverlay<Content, OverlayContent>: View where Content: View, OverlayContent: View {
    let content: Content
    let overlayContent: OverlayContent
    var body: Content {
        content
    }
}

struct ModifierBackground<Content, BackgroundContent>: View where Content: View, BackgroundContent: View {
    let content: Content
    let backgroundContent: BackgroundContent
    var body: Content {
        content
    }
}

struct ModifierFrame<Content>: View where Content: View {
    let size: Size
    let content: Content
    var body: Content {
        content
    }
}

struct ModifierForegroundColor<Content>: View where Content: View {
    let color: Color
    let content: Content
    var body: Content {
        content
    }
}

struct ModifierCornerRadius<Content>: View where Content: View {
    let cornerRadius: CornerRadius
    let content: Content
    var body: Content {
        content
    }
}

struct ModifierFontSize<Content>: View where Content: View {
    let fontSize: Double
    let content: Content
    var body: Content {
        content
    }
}

struct ModifierFontWeight<Content>: View where Content: View {
    let fontWeight: FontWeight
    let content: Content
    var body: Content {
        content
    }
}

struct ModifierTextAlignment<Content>: View where Content: View {
    let alignment: TextAlignment
    let content: Content
    var body: Content {
        content
    }
}

struct ModifierFitTextToParent<Content>: View where Content: View {
    let fitTextToParent: Bool
    let content: Content
    var body: Content {
        content
    }
}

struct ModifierPadding<Content>: View where Content: View {
    let padding: Padding
    let content: Content
    var body: Content {
        content
    }
}

struct ModifierOnAppear<Content>: View where Content: View {
    let action: () -> ()
    let content: Content
    var body: Content {
        content
    }
}

struct ModifierOnDisappear<Content>: View where Content: View {
    let action: () -> ()
    let content: Content
    var body: Content {
        content
    }
}

struct ModifierOnHover<Content>: View where Content: View {
    let action: (Bool) -> ()
    let content: Content
    var body: Content {
        content
    }
}

struct ModifierOnClick<Content>: View where Content: View {
    let action: () -> ()
    let content: Content
    var body: Content {
        content
    }
}
