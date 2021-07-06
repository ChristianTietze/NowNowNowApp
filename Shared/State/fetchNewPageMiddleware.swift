//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import ReSwift
import Foundation
import Kanna

/// Attempts to produce new `NowSnapshot` from `URL`
let fetchNewPageMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            guard case AddNowPage.request(let requestURL) = action
            else { return next(action) }

            func handleClientError(_ error: Error) {}
            func handleServerError(_ response: URLResponse?) {}
            func handleContentError(_ response: URLResponse?, _ data: Data?) {}

            let result = Result {
                try Kanna.HTML(url: requestURL, encoding: .utf8)
            }.map { NowSnapshot(fromHTMLDocument: $0, url: requestURL) }

            switch result {
            case .failure(let error):
                break

            case .success(let snapshot):
                DispatchQueue.main.async {
                    next(AddNowPage.result(.success(snapshot)))
                }
            }
        }
    }
}

extension NowSnapshot {
    init(fromHTMLDocument html: Kanna.HTMLDocument, url: URL) {
        self.init(id: UUID(),
                  title: html.title ?? url.absoluteString,
                  url: url,
                  updatedAt: Date(),
                  content: html.content ?? "(Loading page failed)")
    }
}
