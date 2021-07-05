//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct LoadingIndicatorView: View {
    @Binding var isLoading: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Always display a faint background
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(Color.loadingIndicatorBackgroundColor)
                    .frame(width: geometry.size.width, height: 6, alignment: .center)

                ProgressView()
                    .progressViewStyle(.linear)
                    .opacity(isLoading ? 1.0 : 0.0)
            }
        }
    }
}

extension Color {
    static var loadingIndicatorBackgroundColor: Color {
        #if !os(macOS)
        Color(.systemGray6).opacity(0.8)
        #else
        Color(.lightGray).opacity(0.1)
        #endif
    }
}

struct LoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatorView(isLoading: .constant(true))
    }
}
