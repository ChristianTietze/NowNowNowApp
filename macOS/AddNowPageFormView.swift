//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct AddNowPageFormView: View {
    @EnvironmentObject var dispatcher: Dispatcher
    @StateObject var viewModel = AddNowPageFormView.ViewModel()
    @Binding var showSheetView: Bool

    let sheetTitle = "New Subscription"

    var body: some View {
        VStack {
            // Since macOS 11, dialogs don't have titles, so we cannot see navigationTitle at all and should instead repeat it. But if we use `Form` here as well, the .toolbar won't be applied at the proper place
            Text(sheetTitle)
                .font(.headline)

            Form {
                NowPageURLView(formViewViewModel: viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
                ToolbarItem(placement: .confirmationAction) {
                    subscribeButton
                }
            }
        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
    }

    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
        .keyboardShortcut(.cancelAction)
    }

    private var subscribeButton: some View {
        Button("Add") {
            guard let url = viewModel.validURL else { return }
            dispatcher.dispatch(AddNowPage.request(url: url))
            dismiss()
        }
        .keyboardShortcut(.defaultAction)
        .disabled(viewModel.validURL == nil)
    }

    private func dismiss() {
        showSheetView = false
    }
}

struct NewSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddNowPageFormView(showSheetView: .constant(true))
        }
    }
}
