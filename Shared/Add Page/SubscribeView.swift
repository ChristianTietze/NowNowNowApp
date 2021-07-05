//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct SubscribeView: View {
    @Binding var showSheetView: Bool

    @State var url: String = ""
    let sheetTitle = "New Subscription"

    var body: some View {
        formWrapper {
            Form {
                Section(header: Text("Website")) {
                    urlTextField
                }
            }
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

    private func formWrapper<V: View>(@ViewBuilder _ contents: () -> V) -> some View {
        #if !os(macOS)
        NavigationView {
            contents()
                .navigationBarTitle(sheetTitle, displayMode: .inline)
        }
        #else
        VStack {
            // Since macOS 11, dialogs don't have titles, so we cannot see navigationTitle at all and should instead repeat it. But if we use `Form` here as well, the .toolbar won't be applied at the proper place
            Text(sheetTitle)
                .font(.headline)
            contents()
        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        #endif
    }

    private var urlTextField: some View {
        HStack {
            #if os(macOS)
            // On iOS, placeholder text is the norm, but on macOS, we'd better add a label.
            Text("URL:")
            #endif
            TextField("URL, e.g. sivers.org/now", text: $url)
                .frame(minWidth: 250)
        }
    }

    private var cancelButton: some View {
        Button("Cancel") {
            self.showSheetView = false
        }.keyboardShortcut(.cancelAction)
    }

    private var subscribeButton: some View {
        Button("Add") {
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
