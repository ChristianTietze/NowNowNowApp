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

extension ReSwift.Store {
    func dispatch(_ action: AppAction) {
        self.dispatch(action as ReSwift.Action)
    }
}

enum AppAction: ReSwift.Action {
    case addNowPage(url: URL)
    case deleteSnapshot(NowSnapshot.ID)
    case replaceSnapshots([NowSnapshot])
}

func appReducer(action: ReSwift.Action, state: AppState?) -> AppState {
    return AppState(
        nowSnapshots: nowSnapshotsReducer(action: action, state: state?.nowSnapshots))
}

func nowSnapshotsReducer(action: ReSwift.Action, state: [NowSnapshot]?) -> [NowSnapshot] {
    switch action as? AppAction {
    case .deleteSnapshot(let id):
        var state = state ?? []
        state.removeAll(where: { $0.id == id })
        return state
    case .replaceSnapshots(let newSnapshots):
        return newSnapshots
    case .addNowPage(url: let url):
        return state ?? []
    case .none:
        // Unhandled action type    
        return state ?? []
    }
}

/// <https://github.com/ReSwift/ReSwift/issues/455>
class Subscriber<Value>: ObservableObject, ReSwift.StoreSubscriber {
    @Published private(set) var value: Value!

    init<S: StoreType>(_ store: S, transform: @escaping (ReSwift.Subscription<S.State>) -> ReSwift.Subscription<Value>) {
        store.subscribe(self, transform: transform)
    }

    init<S: StoreType>(_ store: S, transform: @escaping (ReSwift.Subscription<S.State>) -> ReSwift.Subscription<Value>) where Value: Equatable {
        store.subscribe(self, transform: transform)
    }

    func newState(state: Value) {
        value = state
    }
}
