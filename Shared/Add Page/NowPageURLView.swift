//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct NowPageURLView: View {
    @ObservedObject private(set) var urlStatusViewViewModel: URLStatusView.ViewModel

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

                TextField("URL, e.g. https://sivers.org/now", text: $urlStatusViewViewModel.text)
                    .verbatimInput()
                    .modifier(EnforceHTTPSModifier(text: $urlStatusViewViewModel.text))
                    .frame(minWidth: 250)

                URLStatusView(viewModel: urlStatusViewViewModel)
            }
        }
    }

    struct EnforceHTTPSModifier: ViewModifier {
        @Binding var text: String

        func body(content: Content) -> some View {
            content.onChange(of: text) { newValue in
                var result = newValue
                if !newValue.hasPrefix("https://") {
                    // Drop http:// or ftp:// -- when users try to delete parts of the "https://" protocol string, this also cleans that up. We also match single-slash ":/" because that's what you get when you delete backwards right before the domain name.
                    if let separatorRange = result.range(of: "://") ?? result.range(of: ":/") {
                        result = String(result[separatorRange.upperBound...])
                    }
                    result = "https://" + result
                }
                text = result
            }
        }
    }
}
