//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Combine
import Foundation

/// Represents a cached /now page snapshot.
struct NowSnapshot: Identifiable, Equatable, Hashable {
    enum UpdatedAt: Equatable, Hashable {
        /// Date explicitly set by the author to indicate the last change.
        case modifiedAt(Date)

        /// Date of the last time the snapshot was created by the app.
        case fetchedAt(Date)
    }

    let id: UUID

    /// Page title, or user choosen override.
    let title: String

    let url: URL

    let updatedAt: UpdatedAt
    let content: String
    // let icon: CGImage
}
