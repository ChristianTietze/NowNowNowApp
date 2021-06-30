//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct CircleImage: View {
    var image: Image

    var body: some View {
        image
            .resizable()
            .frame(width: 32, height: 32, alignment: .center)
            .fixedSize(horizontal: true, vertical: true)
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            // TODO: Consider adding border back in for all devices and dark/light mode
            // .overlay(Circle().stroke(Color.white, lineWidth: 1))
            // .shadow(color: .black, radius: 2, x: 0, y: 1)
    }
}