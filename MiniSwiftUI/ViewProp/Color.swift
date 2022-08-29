//
// Created by Katsu Matsuda on 2022/07/21.
//

import Foundation

struct Color {
    let r: Double
    let g: Double
    let b: Double
    let a: Double

    init(r: Double, g: Double, b: Double, a: Double = 1.0) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

    init(r: Int, g: Int, b: Int, a: Int = 255) {
        self.r = Double(r) / 255.0
        self.g = Double(g) / 255.0
        self.b = Double(b) / 255.0
        self.a = Double(a) / 255.0
    }
}

extension Color: Equatable {
    public static func ==(lhs: Color, rhs: Color) -> Bool {
        lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.a == rhs.b
    }
}

extension Color {
    static var clear: Color {
        .init(r: 0.0, g: 0.0, b: 0.0, a: 0.0)
    }

    static var white: Color {
        .init(r: 1.0, g: 1.0, b: 1.0)
    }

    static var black: Color {
        .init(r: 0.0, g: 0.0, b: 0.0)
    }

    static var gray: Color {
        .init(r: 142, g: 142, b: 147)
    }

    static var red: Color {
        .init(r: 255, g: 59, b: 48)
    }

    static var orange: Color {
        .init(r: 255, g: 149, b: 0)
    }

    static var yellow: Color {
        .init(r: 255, g: 204, b: 0)
    }

    static var green: Color {
        .init(r: 52, g: 199, b: 89)
    }

    static var mint: Color {
        .init(r: 0, g: 199, b: 190)
    }

    static var teal: Color {
        .init(r: 48, g: 176, b: 199)
    }

    static var cyan: Color {
        .init(r: 50, g: 173, b: 230)
    }

    static var blue: Color {
        .init(r: 0, g: 122, b: 255)
    }

    static var indigo: Color {
        .init(r: 88, g: 86, b: 214)
    }

    static var purple: Color {
        .init(r: 175, g: 82, b: 222)
    }

    static var pink: Color {
        .init(r: 255, g: 45, b: 85)
    }

    static var brown: Color {
        .init(r: 162, g: 132, b: 94)
    }

    func opacity(_ alpha: Double) -> Color {
        .init(r: r, g: g, b: b, a: alpha)
    }
}
