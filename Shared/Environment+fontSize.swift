//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct FontSizeKey: EnvironmentKey {
    #if !os(macOS)
    static var initialValue: Double = UIFont.preferredFont(forTextStyle: .body).pointSize
    #else
    static var initialValue: Double = NSFont.systemFontSize
    #endif

    static var defaultValue: Binding<Double> = Binding.constant(initialValue)
}

extension EnvironmentValues {
    var fontSize: Binding<Double> {
        get { self[FontSizeKey.self] }
        set { self[FontSizeKey.self] = newValue }
    }
}
