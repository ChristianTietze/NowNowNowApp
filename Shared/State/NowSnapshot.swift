//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Combine
import Foundation

/// Represents a cached /now page snapshot.
struct NowSnapshot: Identifiable, Equatable, Hashable {
    let id: UUID

    /// Page title, or user choosen override.
    let title: String

    let url: URL

    let updatedAt: Date
    let content: String
    // let icon: CGImage
}
