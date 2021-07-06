//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

struct UpdatedAtFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()

    private init() {}

    static func string(from updatedAt: NowSnapshot.UpdatedAt) -> String {
        switch updatedAt {
        case .modifiedAt(let date):
            return "Last update: \(dateFormatter.string(from: date))"
        case .fetchedAt(let date):
            return "(Fetched at \(dateFormatter.string(from: date)))"
        }
    }

    static func string(from snapshot: NowSnapshot) -> String {
        return string(from: snapshot.updatedAt)
    }
}
