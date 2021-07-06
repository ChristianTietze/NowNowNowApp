//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI
import ReSwift

/// <https://github.com/ReSwift/ReSwift/issues/455>
class Subscriber<Value>: ObservableObject, ReSwift.StoreSubscriber {
    @Published private(set) var value: Value!

    private init(value: Value) {
        self.value = value
    }

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

#if DEBUG
extension Subscriber {
    static func stub(_ value: Value) -> Subscriber<Value> {
        return Subscriber<Value>(value: value)
    }
}
#endif
