//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation
import SwiftUI

struct NowSnapshotViewModel: Identifiable, Equatable {
    let id: UUID
    
    let title: String
    let updatedAt: String
    let content: String
    let icon: Image
}

extension NowSnapshotViewModel {
    init(fromSnapshot snapshot: NowSnapshot) {
        self.init(id: snapshot.id,
                  title: snapshot.title,
                  updatedAt: UpdatedAtFormatter.string(from: snapshot),
                  content: snapshot.content,
                  // TODO: Use real icon
                  icon: .nowPlaceholderIcon)
    }
}
