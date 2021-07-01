//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct NowSnapshotView: View {
    let snapshot: NowSnapshotViewModel

    var body: some View {
        ScrollView {
        }
    }
}

struct NowSnapshotView_Previews: PreviewProvider {
    static var previews: some View {
        NowSnapshotView(snapshot: NowSnapshotViewModel(id: UUID(), title: "NowNowNow — Amazing Page Title", updatedAt: "2021-07-01 09:27", content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", icon: .nowPlaceholderIcon))
    }
}
