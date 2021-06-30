//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

@main
struct NowNowNowApp: App {
    @StateObject var excerptPresenter: NowExcerptPresenter = NowExcerptPresenter()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                NowExcerptListView(excerpts: $excerptPresenter.excerpts)
                EmptyView()
            }
        }
    }
}
