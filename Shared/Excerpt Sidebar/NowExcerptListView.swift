//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.
 
import SwiftUI

struct NowExcerptListView: View {
    struct State: Equatable {
        let excerpts: [NowExcerptViewModel]
    }

    enum Action: Equatable {
        case delete(NowExcerptViewModel.ID)
    }

    typealias ViewModel = Store<State, Action>

    @ObservedObject var viewModel: ViewModel

    @SwiftUI.State var selectedExcerpt: NowExcerptViewModel? = nil
    @SwiftUI.State var isDeletionAlertShown = false

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
        List {
            ForEach(viewModel.state.excerpts, id: \.id) { excerpt in
                NavigationLink(
                    destination: NowSnapshotView(snapshot: NowSnapshotViewModel(id: excerpt.id, title: excerpt.title, updatedAt: excerpt.updatedAt, content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", icon: excerpt.icon)),
                    tag: excerpt,
                    selection: $selectedExcerpt)
                {
                    NowExcerptView(excerpt: excerpt)
                }
            }
            .onDelete { indexSet in
                indexSet
                    .map { viewModel.state.excerpts[$0].id }
                    .forEach { viewModel.send(.delete($0)) }
            }
            .listStyle(.sidebar)
        }
        .alert(isPresented: $isDeletionAlertShown) { deletionAlert }
        .x_onDeleteCommand { isDeletionAlertShown = true }
    }

    private var deletionAlert: Alert {
        let deletionButton = Alert.Button.destructive(Text("Delete"), action: {
            guard let selectedExcerpt = selectedExcerpt else { return }
            viewModel.send(.delete(selectedExcerpt.id))
        })
        return Alert(title: Text("Delete /now Page?"),
              message: Text("Do you really want to delete this subscription?"),
              primaryButton: deletionButton,
              secondaryButton: .cancel())
    }
}

extension View {
    // Is this weird approach to cross-platform view event handling really the intended way to do things?

    #if !os(macOS)
    /// Does nothing on iOS.
    fileprivate func x_onDeleteCommand(perform action: (() -> Void)?) -> some View {
        self
    }
    #else
    /// Edit > Delete menu item on macOS.
    fileprivate func x_onDeleteCommand(perform action: (() -> Void)?) -> some View {
        self.onDeleteCommand(perform: action)
    }
    #endif
}

struct NowExcerptListView_Previews: PreviewProvider {
    static var previews: some View {
        NowExcerptListView(
            viewModel: .stub(with: .init(excerpts: [
                NowExcerptViewModel(id: UUID(), title: "Test", updatedAt: "2021-06-18", excerpt: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", icon: .nowPlaceholderIcon),
                NowExcerptViewModel(id: UUID(), title: "Test 2", updatedAt: "2021-06-19", excerpt: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum", icon: .nowPlaceholderIcon)
            ])),
            selectedExcerpt: nil)
    }
}
