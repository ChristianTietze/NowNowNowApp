//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI
import Combine

struct URLStatusView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        switch viewModel.status {
        case .initial:
            EmptyView()
        case .pending:
            SpinningLoadingCircleView()
                .modifier(StatusIconModifier(color: .blue))
        case .invalid:
            Image(systemName: "xmark.octagon")
                .modifier(StatusIconModifier(color: .red))
        case .valid:
            Image(systemName: "checkmark.circle")
                .modifier(StatusIconModifier(color: .green))
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
        URLStatusView(
            viewModel: URLStatusView.ViewModel(
                validURL: Just(nil).eraseToAnyPublisher(),
                isPerformingNetworkActivity: Just(true).eraseToAnyPublisher()))
    }
}
