//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation
import Combine

class NowExcerptPresenter: ObservableObject {
    @Published var excerpts: [NowExcerptViewModel]

    init() {
        let urls: [URL] = [
            URL(string: "https://mattgemmell.com/now")!,
            URL(string: "https://sivers.org/now")!,
            URL(string: "https://tyler.io/now/")!,
            URL(string: "https://denisdefreyne.com/now/")!,
            URL(string: "https://christiantietze.de/now")!
        ]

        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            return dateFormatter
        }()
        
        self.excerpts = urls.map { url -> NowExcerptViewModel in
            NowExcerptViewModel(
                id: UUID(),
                title: url.absoluteString,
                updatedAt: dateFormatter.string(from: Date()),
                excerpt: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                icon: .nowPlaceholderIcon)
        }
    }
}
