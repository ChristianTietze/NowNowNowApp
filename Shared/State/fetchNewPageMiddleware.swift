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
    static let iso8601DateFormatter = ISO8601DateFormatter()

    init(fromHTMLDocument html: Kanna.HTMLDocument, url: URL) {
        let content: String
        let updatedAt: Date

        if let hNowElement = html.xpath("//*[contains(@class,'h-now')]", namespaces: nil).first {
            // The h-now microformat expects content to be in any HTML tag with the `.e-content` class, but we should fallback to the whole element text if that's not found.
            content = hNowElement.xpath(".//*[contains(@class,'e-content')]", namespaces: nil).first?.text
                ?? hNowElement.text
                ?? "(h-now microformat specified but no content found)"

            // The microformat also expects the update timestamp to be in a `datetime` attribute inside a HTML tag with the class `.dt-published`.
            let updatedAtString = hNowElement.xpath(".//*[contains(@class,'dt-published')]/@datetime", namespaces: nil).first?.text ?? "No"
            updatedAt = NowSnapshot.iso8601DateFormatter.date(from: updatedAtString)
                ?? Date()
        } else {
            // Fallback to often used content tags
            let contentElement: Kanna.XMLElement? =
                   html.xpath("//main", namespaces: nil).first
                ?? html.xpath("//*[contains(@class,'content') or @id='content']", namespaces: nil).first
                ?? html.css("article", namespaces: nil).first
            content = contentElement?.content ?? "(Finding the body content on the page failed)"
            // TODO: Try to fetch modification date via <head>/<meta> tags?
            updatedAt = Date()
        }

        self.init(id: UUID(),
                  title: html.title ?? url.absoluteString,
                  url: url,
                  updatedAt: updatedAt,
                  content: content)
    }
}
