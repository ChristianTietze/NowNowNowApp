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
