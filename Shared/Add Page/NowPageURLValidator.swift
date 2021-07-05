//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation
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
        (200 ..< 400).contains(statusCode)
        || statusCode == 405
    }
}
