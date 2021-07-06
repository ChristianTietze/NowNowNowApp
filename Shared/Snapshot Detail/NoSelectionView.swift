//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI
import ReSwift

struct NoSelectionView<Store: ReSwift.StoreType>: View {
    private let store: Store

    var nowSnapshotsExist = false

    @Environment(\.minDetailWidth) var minDetailWidth: Binding<Double>
    @Environment(\.minWindowHeight) var minWindowHeight: Binding<Double>

    init(store: Store) {
        self.store = store
    }

    var body: some View {
        Group {
            if nowSnapshotsExist {
                selectPlaceholderView
            } else {
                firstLaunchView
            }
        }.frame(minWidth: minDetailWidth.wrappedValue, minHeight: minWindowHeight.wrappedValue)
    }

    private var selectPlaceholderView: some View {
        Text("Select /now page to read")
    }

    private var firstLaunchView: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Add a /now page to your collection and show the latest update")

            AddSubscriptionButton(store: store, labelStyle: .titleOnly)
        }
    }
}

struct ContentPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        NoSelectionView(store: AppStore())
    }
}
