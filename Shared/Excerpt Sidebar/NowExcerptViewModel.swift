//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation
import SwiftUI

struct NowExcerptViewModel: Identifiable, Equatable {
    let id: UUID

    let title: String
    let updatedAt: String
    let excerpt: String
    let icon: Image
}

extension NowExcerptViewModel {
    init(fromSnapshot snapshot: NowSnapshot) {
        self.init(
            id: snapshot.id,
            title: snapshot.title,
            updatedAt: UpdatedAtFormatter.string(from: snapshot),
            excerpt: String(snapshot.content
                                .replacingOccurrences(of: "\n", with: " ")
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .prefix(200)),
            // TODO: Use real icon
            icon: .nowPlaceholderIcon)
    }
}

