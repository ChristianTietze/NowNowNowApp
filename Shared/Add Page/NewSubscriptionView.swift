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
    @Published var isPerformingNetworkActivity: Bool = false
    @Published var text: String = ""
    @Published var validURL: URL? = nil

    init() {
        let networkActivityPublisher = PassthroughSubject<Bool, Never>()

        networkActivityPublisher
            .receive(on: RunLoop.main)
            .assign(to: &$isPerformingNetworkActivity)

        $text
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap { URL.reachableURL(string: $0, networkActivityPublisher: networkActivityPublisher) }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .assign(to: &$validURL)
    }
}


extension URL {
    /// - Returns: Promise of the URL result.
    static func reachableURL(string: String, networkActivityPublisher: PassthroughSubject<Bool, Never>) -> AnyPublisher<URL?, Never> {
        print(string)
        guard let url = URL(string: string)
        else { return Just(nil).eraseToAnyPublisher() }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"  // Just perform a check, don't fetch content

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .handleEvents(receiveSubscription: { _ in
                networkActivityPublisher.send(true)
            }, receiveCompletion: { _ in
                networkActivityPublisher.send(false)
            }, receiveCancel: {
                networkActivityPublisher.send(false)
            })
            .tryMap { data, response -> URL? in
                guard let urlResponse = response as? HTTPURLResponse,
                      urlResponse.isStatusIndicatedReachability
                else { return nil }
                return urlResponse.url?.absoluteURL
            }
            .catch { err in
                return Just(nil)
            }
            .eraseToAnyPublisher()
    }
}

extension HTTPURLResponse {
    var isStatusIndicatedReachability: Bool {
        (200 ..< 400).contains(statusCode) || statusCode == 405
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
                    .disableAutocorrection(true)
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
