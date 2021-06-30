//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct AddSubscriptionButton: View {
    @State var showSheetView = false

    var body: some View {
        Button(action: {
            self.showSheetView.toggle()
        }, label: {
            Label("Add", systemImage: "plus")
                .labelStyle(.iconOnly)
        }).sheet(isPresented: $showSheetView) {
            SubscribeView(showSheetView: $showSheetView)
        }
    }
}
