//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

/// On iOS, displays a short excerpt to get an overview.
/// On macOS, displays the title only to navigate to the item in the detail pane.
struct NowExcerptView: View {
    @State var excerpt: NowExcerptViewModel

    #if !os(macOS)
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 10) {
                CircleImage(image: excerpt.icon, size: .regular)
                VStack(alignment: .leading) {
                    Text(excerpt.title)
                        .fontWeight(.bold)
                    Text(excerpt.excerpt)
                        .lineLimit(5)
                        .padding(.bottom)
                    if #available(iOS 15.0, *) {
                        Text(excerpt.updatedAt)
                            .dynamicTypeSize(.small)
                            .foregroundColor(.secondary)
                    } else {
                        Text(excerpt.updatedAt)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    #else
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            CircleImage(image: excerpt.icon, size: .regular)
            VStack(alignment: .leading, spacing: nil) {
                Text(excerpt.title)
                Text(excerpt.updatedAt)
                    .controlSize(.small)
                    .foregroundColor(.secondary)
            }
        }
    }
    #endif
}

struct NowExcerptView_Previews: PreviewProvider {
    static var previews: some View {
        NowExcerptView(excerpt: NowExcerptViewModel(id: UUID(), title: "Test", updatedAt: "2021-06-30 09:26", excerpt: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", icon: .nowPlaceholderIcon))
    }
}
