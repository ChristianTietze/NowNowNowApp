//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

typealias AppStore = Store<AppState, AppAction>

struct AppState: Equatable {
    var nowSnapshots: [NowSnapshot] = []
}

enum AppAction {
    case selectSnapshot(NowSnapshot.ID)
}

func appReducer(state: inout AppState, action: AppAction) {
    switch action {
    case .selectSnapshot(let id):
        // TODO: implement
        break
    }
}
