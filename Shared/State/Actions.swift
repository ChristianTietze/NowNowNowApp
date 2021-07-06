//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation
import ReSwift

struct AddNowPage: ReSwift.Action {
    let url: URL
}

struct AddNowSnapshot: ReSwift.Action {
    let snapshot: NowSnapshot
}

struct DeleteNowPage: ReSwift.Action {
    let id: NowSnapshot.ID
}

struct ReplaceSnapshots: ReSwift.Action {
    let snapshots: [NowSnapshot]
}
