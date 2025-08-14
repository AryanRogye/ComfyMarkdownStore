//
//  BlockquoteView.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI
import ComfyMarkdownCore

public struct BlockquoteView: View {
    var node : MarkdownNode
    
    @Environment(\.markdownTheme) private var theme
    @Environment(\.maxFontSize) private var maxHeadingSize
    
    @State private var text: String?
    
    public init(node: MarkdownNode) {
        self.node  = node
    }
    
    public var body: some View {
        Text(node.plainText)
            .italic()
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(
                theme.blockquoteFont(maxHeadingSize: maxHeadingSize)
            )
            .padding(.leading, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(theme.blockquoteBackgroundColor)
                    .opacity(0.1)
            )
    }
}
