//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

extension EnvironmentValues {
    private struct MinWindowHeightKey: EnvironmentKey {
        #if !os(macOS)
        static private var initialValue: Double = 0  // The window will fill the device either way.
        #else
        static private var initialValue: Double = 300  // Smaller text contents look weird. Experimental value.
        #endif

        static var defaultValue: Binding<Double> = Binding.constant(initialValue)
    }

    var minWindowHeight: Binding<Double> {
        get { self[MinWindowHeightKey.self] }
        set { self[MinWindowHeightKey.self] = newValue }
    }
}
