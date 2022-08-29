//
// Created by Katsu Matsuda on 2022/05/24.
//

import Foundation

protocol View {
    associatedtype Body: View
    var body: Self.Body { get }
}
