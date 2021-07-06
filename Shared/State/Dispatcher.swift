//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import ReSwift
import SwiftUI

class Dispatcher: ObservableObject {
    private let store: AppStore

    init(store: AppStore) {
        self.store = store
    }

    func dispatch(_ action: ReSwift.Action) {
        store.dispatch(action)
    }
}
