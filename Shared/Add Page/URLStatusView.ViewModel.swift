//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation
import Combine

extension URLStatusView {
    class ViewModel: ObservableObject {
        enum Status {
            case initial, pending, valid, invalid
        }

        @Published var status: Status = .initial

        init(validURL: AnyPublisher<URL?, Never>,
             isPerformingNetworkActivity: AnyPublisher<Bool, Never>) {

            validURL
                .combineLatest(isPerformingNetworkActivity, Status.init(url:isPending:))
                .assign(to: &$status)
        }
    }
}

extension URLStatusView.ViewModel.Status {
    init(url: URL?, isPending: Bool) {
        switch (url, isPending) {
        case (_, true): self = .pending
        case (.none, false): self = .invalid
        case (.some(_), false): self = .valid
        }
    }
}
