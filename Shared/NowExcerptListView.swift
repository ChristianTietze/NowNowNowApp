//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.
 
import SwiftUI

struct NowExcerptListView: View {
    var excerpts: [NowExcerptViewModel] = [
        NowExcerptViewModel(title: "Test", updatedAt: "2021-06-18", excerpt: "this is a list item"),
        NowExcerptViewModel(title: "Test 2", updatedAt: "2021-06-19", excerpt: "this is another but longer list item"),
    ]

    private var placeholderImage: Image {
        Image("NowClock")
    }

    var body: some View {
        List(excerpts, id: \.title) { item in
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 10) {
                    placeholderImage
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .center)
                        .fixedSize(horizontal: true, vertical: true)
                        .aspectRatio(contentMode: .fill)
                    VStack(alignment: .leading) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(item.title)
                                .fontWeight(.bold)
                            Spacer()
                            Text(item.updatedAt)
                                .foregroundColor(.secondary)
                        }
                        Text(item.excerpt)
                    }
                }
            }
        }
    }
}

struct NowExcerptListView_Previews: PreviewProvider {
    static var previews: some View {
        NowExcerptListView()
    }
}
