//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import ReSwift
import Foundation

typealias AppStore = ReSwift.Store<AppState>

extension AppStore {
    convenience init(state: AppState = AppState()) {
        self.init(reducer: appReducer(action:state:),
                  state: state,
                  middleware: [],
                  automaticallySkipsRepeats: true)
    }
}

func appReducer(action: ReSwift.Action, state: AppState?) -> AppState {
    return AppState(
        nowSnapshots: nowSnapshotsReducer(action: action, state: state?.nowSnapshots))
}

func nowSnapshotsReducer(action: ReSwift.Action, state: [NowSnapshot]?) -> [NowSnapshot] {
    switch action {
    case let action as ReplaceSnapshots:
        return action.snapshots

    case let action as DeleteNowPage:
        var state = state ?? []
        state.removeAll(where: { $0.id == action.id })
        return state
    case .result(.success(let snapshot)) as AddNowPage:
        var state = state ?? []
        state.append(snapshot)
        return state
    default:
        return state ?? []
    }
}
