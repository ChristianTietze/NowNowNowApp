//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

extension NowNowNowApp {
    /// Not implemented this on iOS.
    func fontSizeCommandGroup() -> some Commands {
        CommandGroup(after: .sidebar) {
            // nop
        }
    }
}
