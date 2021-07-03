//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.
 
import SwiftUI

struct NowExcerptListView: View {
    @ObservedObject var store: AppStore

    var excerpts: [NowExcerptViewModel] {
        store.state.nowSnapshots
            .map(NowExcerptViewModel.init(fromSnapshot:))
    }
    @State var selectedExcerpt: NowExcerptViewModel? = nil

    var body: some View {
        listView
            .navigationTitle("All Subscriptions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    AddSubscriptionButton()
                }
            }
    }

    private var listView: some View {
        List(excerpts, id: \.id) { excerpt in
            NavigationLink(
                destination: NowSnapshotView(snapshot: NowSnapshotViewModel(id: excerpt.id, title: excerpt.title, updatedAt: excerpt.updatedAt, content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", icon: excerpt.icon)),
                tag: excerpt,
                selection: $selectedExcerpt)
            {
                NowExcerptView(excerpt: excerpt)
            }
        }.listStyle(.sidebar)
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

struct NowExcerptListView_Previews: PreviewProvider {
    static var previews: some View {
        NowExcerptListView(
            store: AppStore(
                initialState: AppState(nowSnapshots: [
                    NowSnapshot(id: UUID(), title: "Test", url: URL(string: "http://example.com/now")!, updatedAt: Date(), content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
                    NowSnapshot(id: UUID(), title: "Test 2", url: URL(string: "http://example.com/now")!, updatedAt: Date(), content: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"),
                ]),
                reducer: appReducer),
            selectedExcerpt: nil)
    }
}
