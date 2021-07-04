//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct NowSnapshotView: View {
    let snapshot: NowSnapshotViewModel

    @Environment(\.fontSize) private var fontSize: Binding<Double>

    var font: Font {
        Font.system(size: fontSize.wrappedValue, weight: .regular, design: .default)
    }

    var minTextWidth: CGFloat { 200 }

    /// Rough estimate of a readable max width based on the font size.
    /// (Would use `font`'s em-width, but apparently that's not accessible.)
    var maxTextWidth: CGFloat { max(fontSize.wrappedValue * 50, minTextWidth) }

    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    Text(snapshot.title)
                        .font(.title)
                    Spacer()
                    CircleImage(image: snapshot.icon, size: .regular)
                }.padding(.horizontal)

                HStack {
                    Text(snapshot.updatedAt)
                        .foregroundColor(.secondary)
                        .__smallControlSize()
                    Spacer()
                }.padding(.horizontal)

                Text(verbatim: snapshot.content)
                    .font(font)
                    .lineSpacing(4)
                    .padding()  // Padding inside from text to borderk to
                    .background(Color("TextBackgroundColor", bundle: nil))  // TODO: Replace with .init(nsColor:) after macOS 10.12
                    .cornerRadius(4)
            }
            .padding()
            .__enableTextSelection_macOS12_iOS15()
        }
        .titled(snapshot.title)
        .frame(minWidth: minTextWidth, maxWidth: maxTextWidth, alignment: .leading)
    }
}

extension View {
    fileprivate func titled(_ string: String) -> some View {
        #if !os(macOS)
        self.navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(string)
        #else
        // We're keeping the default app name as the main title on macOS
        self.navigationSubtitle(string)
        #endif
    }

    fileprivate func __smallControlSize() -> AnyView {
        // TODO: iOS 15+: Inline .controlSize
        #if os(macOS)
        return AnyView(self.controlSize(.small))
        #elseif os(iOS)
        if #available(iOS 15.0, *) {
            return AnyView(self.controlSize(.small))
        } else {
            return AnyView(self)
        }
        #else
        return AnyView(self)
        #endif
    }

    fileprivate func __enableTextSelection_macOS12_iOS15() -> AnyView {
        // TODO: Drop the `AnyView` in favor of `some View` once the conditions can be removed.
        #if !os(macOS)
        if #available(iOS 15.0, *) {
            return AnyView(self.textSelection(.enabled))
        } else {
            return AnyView(self)
        }
        #else
        if #available(macOS 12.0, *) {
            return AnyView(self.textSelection(.enabled))
        } else {
            return AnyView(self)
        }
        #endif
    }
}

struct NowSnapshotView_Previews: PreviewProvider {
    static var previews: some View {
        NowSnapshotView(snapshot: NowSnapshotViewModel(id: UUID(), title: "NowNowNow — Amazing Page Title", updatedAt: "2021-07-01 09:27", content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", icon: .nowPlaceholderIcon))
    }
}
