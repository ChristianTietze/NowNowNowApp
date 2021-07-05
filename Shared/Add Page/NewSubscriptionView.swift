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

import Combine

class NowPageURLValidator: ObservableObject {
    @Published var text: String = ""

    var potentiallyValidURL: AnyPublisher<URL?, Never> {
        $text
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map(URL.init(string:))
            .map { ($0?.isPotentiallyValid() ?? false) ? $0 : nil }
            .eraseToAnyPublisher()
    }
}

extension URL {
    /// Tests URL for reachability based on `NSURLConnection.canHandle`.
    fileprivate func isPotentiallyValid() -> Bool {
        let request = URLRequest(url: self)
        let canHandle = NSURLConnection.canHandle(request)
        return canHandle
    }
}

struct NowPageURLView: View {
    @StateObject var urlValidator = NowPageURLValidator()
    @State private var validURL: URL?

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
                    .disableAutocorrection(true)
                    .frame(minWidth: 250)
            }

            Text("\(validURL?.absoluteString ?? "")")
                .onReceive(urlValidator.potentiallyValidURL) { validURL = $0 }
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
