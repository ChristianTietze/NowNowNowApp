//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation
import ReSwift

enum AddNowPage: ReSwift.Action {
    case request(url: URL)
    case inProgress
    case result(Result<NowSnapshot, Error>)
}

struct DeleteNowPage: ReSwift.Action {
    let id: NowSnapshot.ID
}

struct ReplaceSnapshots: ReSwift.Action {
    let snapshots: [NowSnapshot]
}
