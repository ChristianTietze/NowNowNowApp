//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation
import SwiftUI

struct NowExcerptViewModel: Identifiable, Equatable, Hashable {
    let id: UUID

    let title: String
    let updatedAt: String
    let excerpt: String
    let icon: Image?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: NowExcerptViewModel, rhs: NowExcerptViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
