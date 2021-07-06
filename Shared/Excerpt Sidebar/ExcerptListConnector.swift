//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

extension Connectors {
    struct ExcerptList: Connector {
        func connect(state: AppState) -> NowExcerptListView.State {
            return .init(excerpts: state.nowSnapshots
                            .map(NowExcerptViewModel.init(fromSnapshot:)))
        }

        func connect(action: NowExcerptListView.Action) -> AppAction {
            switch action {
            case .delete(let id): return .deleteSnapshot(id)
            }
        }
    }

    struct AddPage: Connector {
        func connect(state: AppState) -> Empty {
            return Empty()
        }

        func connect(action: AddNowPageFormView.Action) -> AppAction {
            switch action {
            case .add(url: let url): return .addNowPage(url: url)
            }
        }
    }
}

extension NowExcerptViewModel {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()

    init(fromSnapshot snapshot: NowSnapshot) {
        self.init(
            id: snapshot.id,
            title: snapshot.title,
            updatedAt: NowExcerptViewModel.dateFormatter.string(from: snapshot.updatedAt),
            excerpt: String(snapshot.content.prefix(200)),
            icon: .nowPlaceholderIcon)
    }
}
