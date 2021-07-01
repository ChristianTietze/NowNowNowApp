//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.
 
import SwiftUI

struct NowExcerptListView: View {
    @Binding var excerpts: [NowExcerptViewModel]
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
                destination: EmptyView(),
                tag: excerpt,
                selection: $selectedExcerpt) {
                NowExcerptView(excerpt: excerpt)
            }
        }.listStyle(.sidebar)
    }
}

struct NowExcerptListView_Previews: PreviewProvider {
    static var previews: some View {
        NowExcerptListView(
            excerpts: .constant([
                NowExcerptViewModel(id: UUID(), title: "Test", updatedAt: "2021-06-18", excerpt: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", icon: .nowPlaceholderIcon),
                NowExcerptViewModel(id: UUID(), title: "Test 2", updatedAt: "2021-06-19", excerpt: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum", icon: .nowPlaceholderIcon),
            ]),
            selectedExcerpt: nil)
    }
}
