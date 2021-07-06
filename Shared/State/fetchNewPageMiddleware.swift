//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import ReSwift
import Foundation

/// Attempts to produce new `NowSnapshot` from `URL`
let fetchNewPageMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            guard case AddNowPage.request(let requestURL) = action
            else { return next(action) }

            func handleClientError(_ error: Error) {}
            func handleServerError(_ response: URLResponse?) {}
            func handleContentError(_ response: URLResponse?, _ data: Data?) {}

            URLSession.shared
                .dataTask(with: requestURL) { data, response, error in
                    if let error = error {
                        return handleClientError(error)
                    }

                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode)
                    else { return handleServerError(response) }

                    // TODO: Support non-UTF-8 encoded URL response data
                    guard let string = data.flatMap({ String(data: $0, encoding: .utf8) })
                    else { return handleContentError(response, data) }

                    let pageTitle = "Stub title"
                    let pageContent = string

                    let snapshot = NowSnapshot(
                        id: UUID(),
                        title: pageTitle,
                        url: httpResponse.url?.absoluteURL ?? requestURL,
                        updatedAt: Date(),
                        content: pageContent)

                    DispatchQueue.main.async {
                        next(AddNowPage.result(.success(snapshot)))
                    }
                }.resume()
        }
    }
}
