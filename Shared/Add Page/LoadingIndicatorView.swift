//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct LoadingIndicatorView: View {
    @Binding var isLoading: Bool

    var body: some View {
        ProgressView()
            .progressViewStyle(.linear)
            .opacity(isLoading ? 1.0 : 0.0)
    }
}

struct LoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatorView(isLoading: .constant(true))
    }
}
