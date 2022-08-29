//
// Created by Katsu Matsuda on 2022/07/25.
//

import Foundation

class ViewGraphNodeManager {

    private var idDic: [String: Int]

    init() {
        idDic = .init()
    }

    // return whether the view is appearing
    func register(id: String) -> Bool {
        idDic[id] = (idDic[id] ?? 0) + 1
        return idDic[id] == 1
    }

    // return whether the view is disappearing
    func unregister(id: String) -> Bool {
        idDic[id] = (idDic[id] ?? 1) - 1
        return idDic[id] == 0
    }
}
