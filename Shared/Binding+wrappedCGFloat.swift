//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

extension Binding where Value == Double {
    // TODO: Is obsolete with Xcode 13
    var wrappedCGFloat: CGFloat { CGFloat(wrappedValue) }
}
