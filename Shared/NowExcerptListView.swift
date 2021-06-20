//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.
 
import SwiftUI

struct NowExcerptListView: View {
    var excerpts: [NowExcerptViewModel] = [
        NowExcerptViewModel(title: "Test", updatedAt: "2021-06-18", excerpt: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", icon: nil),
        NowExcerptViewModel(title: "Test 2", updatedAt: "2021-06-19", excerpt: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum", icon: nil),
    ]

    private var placeholderImage: Image {
        Image("NowClock")
    }

    var body: some View {
        List(excerpts, id: \.title) { item in
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 10) {
                    CircleImage(image: item.icon ?? placeholderImage)
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
