//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

@main
struct NowNowNowApp: App {
    private let store = AppStore()
    private let dispatcher: Dispatcher

    @AppStorage("fontSize") var fontSize: Double = FontSizeKey.initialValue

    init() {
        self.dispatcher = Dispatcher(store: store)
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                NowExcerptListView(snapshots: Subscriber(store) { $0.select(\.nowSnapshots) })
                NoSelectionView()
            }
            .environment(\.fontSize, $fontSize)
            .environmentObject(dispatcher)
            .onAppear {
                let urls: [URL] = [
                    URL(string: "https://mattgemmell.com/now")!,
                    URL(string: "https://sivers.org/now")!,
                    URL(string: "https://tyler.io/now/")!,
                    URL(string: "https://denisdefreyne.com/now/")!,
                    URL(string: "https://christiantietze.de/now")!
                ]
                for url in urls {
                    store.dispatch(AddNowPage.request(url: url))
                }
            }
        }
        // Font +/- menu items for macOS; irrelevant on iOS due to dynamic type.
        .commands { fontSizeCommandGroup() }
    }
}

struct MenuButtonStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
            .padding(.bottom, 2)
            .padding(.top, 1)
    }
}
