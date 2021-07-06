//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import SwiftUI

struct NowSnapshotView: View {
    let snapshot: NowSnapshotViewModel

    @Environment(\.minDetailWidth) var minTextWidth: Binding<Double>
    @Environment(\.minWindowHeight) var minWindowHeight: Binding<Double>
    @Environment(\.fontSize) private var fontSize: Binding<Double>

    var font: Font {
        #if !os(macOS)
        // Use dynamic font on iOS. Users can increase the font size system-wide.
        Font.body
        #else
        // Use custom font size on macOS. Users can increase/decrease the font size via `Command`s because
        // the default body size is a bit small to comfortable *read* a text.
        Font.system(size: fontSize.wrappedCGFloat, weight: .regular, design: .default)
            .leading(.loose)
        #endif
    }

    /// Rough estimate of a readable max width based on the font size.
    /// (Would use `font`'s em-width, but apparently that's not accessible.)
    var maxTextWidth: CGFloat { max(fontSize.wrappedCGFloat * 50, minTextWidth.wrappedCGFloat) }

    var body: some View {
        GeometryReader { geometry in
            Group {
                VStack(alignment: .leading, spacing: 0) {
                    VStack {
                        HStack(alignment: .top, spacing: 10) {
                            Text(snapshot.title)
                                .font(.title)
                            Spacer()
                            CircleImage(image: snapshot.icon, size: .regular)
                        }

                        HStack {
                            Text(snapshot.updatedAt)
                                .foregroundColor(.secondary)
                                .__smallControlSize()
                            Spacer()
                        }
                    }
                    .padding()

                    Divider()

                    ScrollView {
                        Text(verbatim: snapshot.content)
                            .font(font)
                            .padding()
                    }
                    .__enableTextSelection_macOS12_iOS15()
                }
                .titled(snapshot.title)
                // Center the text in a column on large devices
                .frame(minWidth: minTextWidth.wrappedCGFloat, maxWidth: maxTextWidth, alignment: .leading)
            }
            // Use the whole width of the detail pane and color it uniformly.
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .modifier(MacOSTextBackgroundColor())
        }
        // Repeat the minWidth for the GeometryReader container so it pushes the window's minimum width.
        .frame(minWidth: minTextWidth.wrappedCGFloat, minHeight: minWindowHeight.wrappedCGFloat)
    }

    struct MacOSTextBackgroundColor: ViewModifier {
        func body(content: Content) -> some View {
            #if !os(macOS)
            content
            #else
            // TODO: Replace with .init(nsColor:) after bumping to macOS 10.12
            content.background(Color("TextBackgroundColor", bundle: nil))
            #endif
        }
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
            #if swift(>=5.5)
            // Coincides with Xcode 13 and new SDKs
            return AnyView(self.controlSize(.small))
            #else
            return AnyView(self)
            #endif
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
            #if swift(>=5.5)
            // Coincides with Xcode 13 and new SDKs
            return AnyView(self.textSelection(.enabled))
            #else
            return AnyView(self)
            #endif
        } else {
            return AnyView(self)
        }
        #else
        if #available(macOS 12.0, *) {
            #if swift(>=5.5)
            // Coincides with Xcode 13 and new SDKs
            return AnyView(self.textSelection(.enabled))
            #else
            return AnyView(self)
            #endif
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
