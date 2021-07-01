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
