//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct AddSubscriptionButton<Style: LabelStyle>: View {
    let labelStyle: Style

    @EnvironmentObject var store: AppStore
    @State var showSheetView = false

    var body: some View {
        Button(action: {
            self.showSheetView.toggle()
        }, label: {
            Label("Add /now Page", systemImage: "plus")
                .labelStyle(labelStyle)
        }).sheet(isPresented: $showSheetView) {
            AddNowPageFormView(viewModel: store.connect(using: Connectors.AddPage()),
                               showSheetView: $showSheetView)
        }
    }
}
