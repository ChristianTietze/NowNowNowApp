//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import CoreGraphics
import SwiftUI

extension Image {
    static let nowPlaceholderIcon = CGImage.nowPlaceholderIcon.image(label: Text("Fallback icon"))
}

#if os(OSX)
import AppKit
extension CGImage {
    static let nowPlaceholderIcon: CGImage = NSImage(named: "NowClock")!
        .cgImage(forProposedRect: nil, context: nil, hints: nil)!
}
#else
import UIKit
extension CGImage {
    static let nowPlaceholderIcon: CGImage = UIImage(named: "NowClock")!.cgImage!
}
#endif

extension CGImage {
    /// - Parameter label: Accessibility label.
    func image(label: Text) -> Image {
        Image(self, scale: 1.0, label: label)
    }
}
