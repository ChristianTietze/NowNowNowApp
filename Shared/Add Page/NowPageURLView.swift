//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct NowPageURLView: View {
    @ObservedObject var urlValidator: NowPageURLValidator

    var body: some View {
        urlTextField
    }

    private var urlTextField: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center) {
                #if os(macOS)
                // On iOS, placeholder text is the norm, but on macOS, we'd better add a label.
                Text("URL:")
                #endif

                TextField("URL, e.g. https://sivers.org/now", text: $urlValidator.text)
                    .verbatimInput()
                    .frame(minWidth: 250)

                URLStatusView(urlValidator: urlValidator)
            }
        }
    }
}
