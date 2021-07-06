//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.
 
import SwiftUI
import ReSwift

protocol HasNowSnapshots {
    var nowSnapshots: [NowSnapshot] { get }
}

extension AppState: HasNowSnapshots {}

struct NowExcerptListView<Store: ReSwift.StoreType>: View where Store.State: HasNowSnapshots {
    private let store: Store

    @ObservedObject private var snapshots: Subscriber<[NowSnapshot]>

    @SwiftUI.State var selectedSnapshot: NowSnapshot? = nil
    @SwiftUI.State var isDeletionAlertShown = false

    init(store: Store) {
        self.store = store
        self.snapshots = Subscriber(store) { $0.select(\.nowSnapshots) }
    }

    var body: some View {
        listView
            .navigationTitle("All /now Pages")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    AddSubscriptionButton(store: store,
                                          labelStyle: .iconOnly)
                }
            }
    }

    private var listView: some View {
        List {
            ForEach(snapshots.value, id: \.id) { snapshot in
                NavigationLink(
                    destination: NowSnapshotView(snapshot: NowSnapshotViewModel(fromSnapshot: snapshot)),
                    tag: snapshot,
                    selection: $selectedSnapshot)
                {
                    NowExcerptView(excerpt: NowExcerptViewModel(fromSnapshot: snapshot))
                }
            }
            .onDelete { indexSet in
                // Delete selected items on iOS right away
                indexSet
                    .map { snapshots.value[$0].id }
                    .forEach { store.dispatch(DeleteNowPage(id: $0)) }
            }
        }
        .frame(minWidth: 200, alignment: .topLeading)
        .modifier(UniversalSidebarStyleModifier())
        .alert(isPresented: $isDeletionAlertShown) { deletionAlert }
        .__onDeleteCommand { isDeletionAlertShown = true }
    }

    private var deletionAlert: Alert {
        let deletionButton = Alert.Button.destructive(Text("Delete"), action: {
            guard let selectedSnapshot = selectedSnapshot else { return }
            store.dispatch(DeleteNowPage(id: selectedSnapshot.id))
        })
        return Alert(title: Text("Delete /now Page?"),
              message: Text("Do you really want to delete this subscription?"),
              primaryButton: deletionButton,
              secondaryButton: .cancel())
    }
}

struct UniversalSidebarStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        #if !os(macOS)
        // .sidebar would be inappropriate because we're displaying larger content cells, like
        // mails in Mail.app, and unlike mailboxes/accounts.
        content.listStyle(.inset)
        #else
        // On macOS, we display only the /now page subscriptions, so a Sidebar is a better fit.
        // Also, .inset as the leftmost split doesn't paint the window title bar correctly.
        content.listStyle(.sidebar)
        #endif
    }
}

extension View {
    // Is this weird approach to cross-platform view event handling really the intended way to do things?

    #if !os(macOS)
    /// Does nothing on iOS.
    fileprivate func __onDeleteCommand(perform action: (() -> Void)?) -> some View {
        self
    }
    #else
    /// Edit > Delete menu item on macOS.
    fileprivate func __onDeleteCommand(perform action: (() -> Void)?) -> some View {
        self.onDeleteCommand(perform: action)
    }
    #endif
}

struct NowExcerptListView_Previews: PreviewProvider {
    static var previews: some View {
        NowExcerptListView(
            store: AppStore(state: .init(nowSnapshots: [
                NowSnapshot(id: UUID(), title: "Test", url: URL(string: "irrelevant")!, updatedAt: Date(), content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
                NowSnapshot(id: UUID(), title: "Test 2", url: URL(string: "irrelevant")!, updatedAt: Date(), content: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")
            ])))
    }
}
