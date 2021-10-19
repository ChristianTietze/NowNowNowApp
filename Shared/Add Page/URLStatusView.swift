//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct URLStatusView: View {
    @ObservedObject private(set) var viewModel: AddNowPageFormView.ViewModel

    var body: some View {
        if viewModel.isPerformingNetworkActivity {
            SpinningLoadingCircleView()
                .modifier(StatusIconModifier(color: .blue))
        } else {
            let isValid = (viewModel.validURL != nil)
            if isValid {
                Image(systemName: "checkmark.circle")
                    .modifier(StatusIconModifier(color: .green))
            } else {
                Image(systemName: "xmark.octagon")
                    .modifier(StatusIconModifier(color: .red))
            }
        }
    }

    private struct StatusIconModifier: ViewModifier {
        let color: Color

        func body(content: Content) -> some View {
            content
                .foregroundColor(color)
                .font(.system(size: 18))
                .frame(width: 20, height: 20, alignment: .center)
        }
    }
}

struct URLStatusView_Previews: PreviewProvider {
    static var previews: some View {
        URLStatusView(viewModel: AddNowPageFormView.ViewModel())
    }
}
