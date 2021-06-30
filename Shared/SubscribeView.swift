//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct SubscribeView: View {
    @Binding var showSheetView: Bool

    @State var url: String = ""
    let sheetTitle = "Add New Subscription"

    var body: some View {
        formWrapper {
            HStack {
                Text("URL:")
                TextField("e.g. sivers.org/now", text: $url)
                    .frame(minWidth: 250)
            }
            .navigationTitle(sheetTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
                ToolbarItem(placement: .confirmationAction) {
                    subscribeButton
                }
            }
        }
    }

    @ViewBuilder
    private func formWrapper<V: View>(@ViewBuilder _ contents: () -> V) -> some View {
        #if !os(macOS)
        NavigationView {
            List {
                contents()
            }
        }
        #else
        VStack {
            // Since macOS 11, dialogs don't have titles, so we cannot see navigationTitle at all and should instead repeat it
            Text(sheetTitle).bold()
            contents()
        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        #endif
    }

    private var cancelButton: some View {
        Button("Cancel") {
            self.showSheetView = false
        }.keyboardShortcut(.cancelAction)
    }

    private var subscribeButton: some View {
        Button("Subscribe") {
            print("subscribe to", url)
        }.keyboardShortcut(.defaultAction)
    }
}

struct SubscribeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SubscribeView(showSheetView: .constant(true))
                  }
    }
}
