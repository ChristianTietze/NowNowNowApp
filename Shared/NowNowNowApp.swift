//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

@main
struct NowNowNowApp: App {
    @StateObject var store = AppStore.fixture()
    @AppStorage("fontSize") var fontSize: Double = FontSizeKey.initialValue

    var body: some Scene {
        WindowGroup {
            NavigationView {
                NowExcerptListView(viewModel: store.connect(using: Connectors.ExcerptList()),
                                   selectedExcerpt: nil)
                EmptyView()
            }.environment(\.fontSize, $fontSize)
        }
        .commands {
            CommandGroup(after: .sidebar) {
                Button(action: {
                    fontSize = min(fontSize + 1, 64)
                }) {
                    Text("Increase Font Size")
                }
                .modifier(MenuButtonStyling())
                .keyboardShortcut(KeyEquivalent("+"), modifiers: [.command])

                Button(action: {
                    fontSize = max(fontSize - 1, 8)
                }) {
                    Text("Decrease Font Size")
                }
                .modifier(MenuButtonStyling())
                .keyboardShortcut(KeyEquivalent("-"), modifiers: [.command])

                Button(action: {
                    fontSize = FontSizeKey.initialValue
                }) {
                    Text("Reset to Default Font Size")
                }
                .modifier(MenuButtonStyling())
                .keyboardShortcut(KeyEquivalent("0"), modifiers: [.command])


                Divider()  // (After this comes the Enter/Exit Full Screen Menu)
            }
        }
    }
}

extension AppStore {
    fileprivate static func fixture() -> Store<AppState, AppAction> {
        let urls: [URL] = [
            URL(string: "https://mattgemmell.com/now")!,
            URL(string: "https://sivers.org/now")!,
                URL(string: "https://tyler.io/now/")!,
            URL(string: "https://denisdefreyne.com/now/")!,
            URL(string: "https://christiantietze.de/now")!
        ]
        let snapshots = urls.enumerated().map { i, url -> NowSnapshot in
            NowSnapshot(
                id: UUID(),
                title: url.host!,
                url: url,
                updatedAt: Date(timeIntervalSinceNow: TimeInterval(-3600 * i)),
                content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\n\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
        }
        return Store<AppState, AppAction>(
            initialState: AppState(nowSnapshots: snapshots),
            reducer: appReducer)
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
