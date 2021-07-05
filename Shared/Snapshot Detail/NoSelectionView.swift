//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct NoSelectionView: View {
    var nowSnapshotsExist = false

    var body: some View {
        if nowSnapshotsExist {
            selectPlaceholderView
        } else {
            firstLaunchView
        }
    }

    private var selectPlaceholderView: some View {
        Text("Select /now page to read")
    }

    private var firstLaunchView: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Add a /now page to your collection and show the latest update")

            AddSubscriptionButton(labelStyle: .titleOnly)
        }
    }
}

struct ContentPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        NoSelectionView()
    }
}
