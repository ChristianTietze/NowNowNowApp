//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.
 
import SwiftUI

struct NowExcerptListView: View {
    var excerpts: [NowExcerptViewModel] = [
        NowExcerptViewModel(title: "Test", updatedAt: "2021-06-18", excerpt: "this is a list item"),
        NowExcerptViewModel(title: "Test 2", updatedAt: "2021-06-19", excerpt: "this is another but longer list item"),
    ]

    var body: some View {
        List(excerpts, id: \.title) { item in
            VStack(alignment: .leading) {
                Text(item.title).fontWeight(.bold)
                Text(item.updatedAt)
                Text(item.excerpt)
            }
        }
    }
}

struct NowExcerptListView_Previews: PreviewProvider {
    static var previews: some View {
        NowExcerptListView()
    }
}
