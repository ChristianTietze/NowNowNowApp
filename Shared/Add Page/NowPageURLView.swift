//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct NowPageURLView: View {
    @ObservedObject var urlValidator: NowPageURLValidator

    var body: some View {
        urlTextField
    }

    private var urlTextField: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                #if os(macOS)
                // On iOS, placeholder text is the norm, but on macOS, we'd better add a label.
                Text("URL:")
                #endif

                TextField("URL, e.g. sivers.org/now", text: $urlValidator.text)
                    .unfilteredInput()
                    .frame(minWidth: 250)
            }

            LoadingIndicatorView(isLoading: $urlValidator.isPerformingNetworkActivity)
        }
    }
}
