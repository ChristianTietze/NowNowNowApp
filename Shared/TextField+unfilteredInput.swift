//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

extension TextField {
    /// Do not auto-correct user input in any way. Works on all platforms.
    func verbatimInput() -> some View {
        modifier(VerbatimInputModifier())
    }
}

struct VerbatimInputModifier: ViewModifier {
    func body(content: Content) -> some View {
        #if !os(macOS)
        content
            .disableAutocorrection(true)
            .autocapitalization(.none)
        #else
        content
            .disableAutocorrection(true)
        #endif
    }
}
