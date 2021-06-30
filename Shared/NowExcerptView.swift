//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct NowExcerptView: View {
    @State var excerpt: NowExcerptViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 10) {
                CircleImage(image: excerpt.icon)
                VStack(alignment: .leading) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(excerpt.title)
                            .fontWeight(.bold)
                        Spacer()
                        Text(excerpt.updatedAt)
                            .foregroundColor(.secondary)
                    }
                    Text(excerpt.excerpt)
                        .lineLimit(5)
                }
            }
        }
    }
}

struct NowExcerptView_Previews: PreviewProvider {
    static var previews: some View {
        NowExcerptView(excerpt: NowExcerptViewModel(id: UUID(), title: "Test", updatedAt: "2021-06-30 09:26", excerpt: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", icon: .nowPlaceholderIcon))
    }
}
