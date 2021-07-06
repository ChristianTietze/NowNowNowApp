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
            })
        $state
            .map(deriveState)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &store.$state)
        return store
    }
}

extension Store {
    static func stub(with state: State) -> Store {
        Store(initialState: state,
              reducer: { _, _ in })
    }
}

// MARK: Connectors: Adapters of actions and presenters of view state

/// Namespace for `Connector` types.
enum Connectors {}

/// See <https://swiftwithmajid.com/2021/02/03/redux-like-state-container-in-swiftui-part4/>
protocol Connector {
    associatedtype State
    associatedtype Action
    associatedtype ViewState: Equatable
    associatedtype ViewAction: Equatable

    func connect(state: State) -> ViewState
    func connect(action: ViewAction) -> Action
}

/// Empty state, like void, but `Equatable`.
struct Empty: Equatable {
    init() {}

    static func == (lhs: Empty, rhs: Empty) -> Bool {
        return true
    }
}

extension Store {
    /// See <https://swiftwithmajid.com/2021/02/03/redux-like-state-container-in-swiftui-part4/>
    func connect<C: Connector>(
        using connector: C
    ) -> Store<C.ViewState, C.ViewAction> where C.State == State, C.Action == Action {
        derived(
            deriveState: connector.connect(state:),
            embedAction: connector.connect(action:)
        )
    }
}
