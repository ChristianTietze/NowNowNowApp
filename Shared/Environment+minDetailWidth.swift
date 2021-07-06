//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

extension EnvironmentValues {
    private struct MinDetailWidthKey: EnvironmentKey {
        #if !os(macOS)
        static private var initialValue: Double = 200
        #else
        static private var initialValue: Double = 400
        #endif

        static var defaultValue: Binding<Double> = Binding.constant(initialValue)
    }

    var minDetailWidth: Binding<Double> {
        get { self[MinDetailWidthKey.self] }
        set { self[MinDetailWidthKey.self] = newValue }
    }
}
