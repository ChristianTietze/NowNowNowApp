//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

typealias AppStore = Store<AppState, AppAction>

extension AppStore {
    convenience init() {
        self.init(initialState: AppState(),
                  reducer: appReducer(state:action:))
    }
}

struct AppState: Equatable {
    var nowSnapshots: [NowSnapshot] = []
}

enum AppAction {
    case addNowPage(url: URL)
    case deleteSnapshot(NowSnapshot.ID)
    case replaceSnapshots([NowSnapshot])
}

func appReducer(state: inout AppState, action: AppAction) {
    switch action {
    case .deleteSnapshot(let id):
        state.nowSnapshots.removeAll(where: { $0.id == id })
    case .replaceSnapshots(let newSnapshots):
        state.nowSnapshots = newSnapshots
    case .addNowPage(url: let url):
        break
    }
}
