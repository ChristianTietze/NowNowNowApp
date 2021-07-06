//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI
import ReSwift

struct AddSubscriptionButton<Style: LabelStyle, Store: ReSwift.StoreType>: View {
    private let store: Store

    let labelStyle: Style

    @State var showSheetView = false

    init(store: Store, labelStyle: Style) {
        self.store = store
        self.labelStyle = labelStyle
    }

    var body: some View {
        Button(action: {
            self.showSheetView.toggle()
        }, label: {
            Label("Add /now Page", systemImage: "plus")
                .labelStyle(labelStyle)
        }).sheet(isPresented: $showSheetView) {
            AddNowPageFormView(store: store,
                               showSheetView: $showSheetView)
        }
    }
}
