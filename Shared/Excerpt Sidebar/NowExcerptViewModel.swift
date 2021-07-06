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

// Hashability is needed for e.g. NavigationLink.tag
extension NowExcerptViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension NowExcerptViewModel {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()

    init(fromSnapshot snapshot: NowSnapshot) {
        self.init(
            id: snapshot.id,
            title: snapshot.title,
            updatedAt: NowExcerptViewModel.dateFormatter.string(from: snapshot.updatedAt),
            excerpt: String(snapshot.content.prefix(200)),
            icon: .nowPlaceholderIcon)
    }
}

