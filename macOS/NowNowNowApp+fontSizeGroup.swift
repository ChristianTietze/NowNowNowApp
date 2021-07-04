//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

extension NowNowNowApp {
    func fontSizeCommandGroup() -> some Commands {
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
