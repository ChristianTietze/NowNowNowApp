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
    // TODO: Reuse same formatter as NowExcerptViewModel.dateFormatter
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()

    init(fromSnapshot snapshot: NowSnapshot) {
        self.init(id: snapshot.id,
                  title: snapshot.title,
                  updatedAt: NowExcerptViewModel.dateFormatter.string(from: snapshot.updatedAt),
                  content: snapshot.content,
                  // TODO: Use real icon
                  icon: .nowPlaceholderIcon)
    }
}
