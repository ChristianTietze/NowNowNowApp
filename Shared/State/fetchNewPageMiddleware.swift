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
    static let fallbackDateFormatters: [DateFormatter] = {
        return [
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd HH:mm:ssZZZZZ",
            "yyyy-MM-dd HH:mm:ss ZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-dd HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-dd HH:mm:ss.SSS ZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd HH:mm:ss'Z'",
            "yyyy-MM-dd HH:mm:ss 'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd HH:mm:ss.SSS"
        ].map { format -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter
        }
    }()

    static func date(from string: String) -> Date? {
        return iso8601DateFormatter.date(from: string)
            ?? fallbackDateFormatters.lazy.compactMap { $0.date(from: string) }.first
    }

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
            updatedAt = NowSnapshot.date(from: updatedAtString) ?? Date()
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
