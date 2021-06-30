//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct CircleImage: View {
    var image: Image

    enum Size: CGFloat {
        case regular = 32
        case small = 16
    }

    let size: Size

    var body: some View {
        image
            .resizable()
            .frame(width: size.rawValue, height: size.rawValue, alignment: .center)
            .fixedSize(horizontal: true, vertical: true)
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            // TODO: Consider adding border back in for all devices and dark/light mode
            // .overlay(Circle().stroke(Color.white, lineWidth: 1))
            // .shadow(color: .black, radius: 2, x: 0, y: 1)
    }
}
