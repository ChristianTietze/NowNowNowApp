//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct AddNowPageFormView: View {
    @EnvironmentObject var dispatcher: Dispatcher
    @StateObject var viewModel = AddNowPageFormView.ViewModel()
    @Binding var showSheetView: Bool

    let sheetTitle = "New Subscription"

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Website")) {
                    NowPageURLView(formViewViewModel: viewModel)
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
            .navigationBarTitle(sheetTitle, displayMode: .inline)
        }
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
        AddNowPageFormView(showSheetView: .constant(true))
    }
}
