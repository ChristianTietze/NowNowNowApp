//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

typealias AppStore = Store<AppState, AppAction>

struct AppState: Equatable {
    var nowSnapshots: [NowSnapshot] = []
}

enum AppAction {
    case deleteSnapshot(NowSnapshot.ID)
}

func appReducer(state: inout AppState, action: AppAction) {
    switch action {
    case .deleteSnapshot(let id):
        state.nowSnapshots.removeAll(where: { $0.id == id })
    }
}
