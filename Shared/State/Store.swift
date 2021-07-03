//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Combine
import Dispatch

// The Redux-like store/reducer/action stuff is adapted from Majid Jabrayilov's
// series that starts here:
// <https://swiftwithmajid.com/2019/09/18/redux-like-state-container-in-swiftui/>

typealias Reducer<State, Action> = (inout State, Action) -> Void

final class Store<State, Action>: ObservableObject {
    @Published private(set) var state: State

    private let reducer: Reducer<State, Action>

    init(initialState: State, reducer: @escaping Reducer<State, Action>) {
        self.state = initialState
        self.reducer = reducer
    }

    func send(_ action: Action) {
        reducer(&state, action)
    }
}

extension Store {
    /// Produce a derived state store, i.e. a sub-state selector that produces change events for its selection.
    /// 
    /// See <https://swiftwithmajid.com/2019/09/25/redux-like-state-container-in-swiftui-part2/>
    func derived<DerivedState: Equatable, ExtractedAction>(
        deriveState: @escaping (State) -> DerivedState,
        embedAction: @escaping (ExtractedAction) -> Action
    ) -> Store<DerivedState, ExtractedAction> {
        let store = Store<DerivedState, ExtractedAction>(
            initialState: deriveState(state),
            reducer: { _, action in
                self.send(embedAction(action))
            }
        )
        $state
            .map(deriveState)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &store.$state)
        return store
    }
}
