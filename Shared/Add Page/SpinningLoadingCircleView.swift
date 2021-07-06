//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct SpinningLoadingCircleView : View {
    @State var isAnimating = false

    var body: some View {
        Image(systemName: "arrow.2.circlepath")
            .rotationEffect(Angle(degrees: isAnimating ? 360.0 : 0.0))
            .animation(.linear(duration: 3.0).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

struct SpinningLoadingCircleView_Previews: PreviewProvider {
    static var previews: some View {
        SpinningLoadingCircleView()
    }
}
