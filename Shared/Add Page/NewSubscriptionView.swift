//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct NewSubscriptionView: View {
    @Binding var showSheetView: Bool

    let sheetTitle = "New Subscription"

    var body: some View {
        formWrapper {
            Form {
                Section(header: Text("Website")) {
                    NowPageURLView()
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

    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }.keyboardShortcut(.cancelAction)
    }

    private var subscribeButton: some View {
        Button("Add") {
            dismiss()
        }.keyboardShortcut(.defaultAction)
    }

    private func dismiss() {
        showSheetView = false
    }
}

struct NowPageURLView: View {
    @StateObject var urlValidator = NowPageURLValidator()

    var body: some View {
        urlTextField
    }

    private var urlTextField: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                #if os(macOS)
                // On iOS, placeholder text is the norm, but on macOS, we'd better add a label.
                Text("URL:")
                #endif

                TextField("URL, e.g. sivers.org/now", text: $urlValidator.text)
                    .unfilteredInput()
                    .frame(minWidth: 250)
            }

            Text(urlValidator.isPerformingNetworkActivity ? "Active" : "-")

            Text(urlValidator.validURL.map(\.absoluteString) ?? "(none)")

        }
    }
}

struct NewSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NewSubscriptionView(showSheetView: .constant(true))
        }
    }
}
