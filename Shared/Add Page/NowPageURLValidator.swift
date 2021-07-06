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

        // Make sure to skip duplicates both in requests and immediate invalidations.
        let uniqueURLStrings = $text.removeDuplicates()

        // Immediately invalidate when user types. Otherwise one could enter a valid URL, validate the form to enable the "Add" button, then type another character and quickly hit Enter to effectively confirm an invalid URL.
        uniqueURLStrings
            .map { _ in nil }
            .assign(to: &$validURL)

        uniqueURLStrings
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .compactMap { URL.reachableURL(string: $0, networkActivityPublisher: networkActivityPublisher) }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .assign(to: &$validURL)
    }
}

extension URL {
    /// Code adapted from <https://stackoverflow.com/questions/57982334/url-verification-publisher>
    /// - Returns: Promise of the URL result.
    static func reachableURL(string: String, networkActivityPublisher: PassthroughSubject<Bool, Never>) -> AnyPublisher<URL?, Never> {
        guard let url = URL(string: string)
        else { return Just(nil).eraseToAnyPublisher() }

        // Start activity indication early
        networkActivityPublisher.send(true)

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
