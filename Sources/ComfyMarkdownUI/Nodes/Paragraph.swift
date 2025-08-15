//
//  Paragraph.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI
import ComfyMarkdownCore

public struct ParagraphView: View {
    var node: MarkdownNode
    
    @Environment(\.markdownTheme) private var theme
    @Environment(\.maxFontSize) private var maxHeadingSize
    
    public init(node: MarkdownNode) {
        self.node = node
    }
    
    public var body: some View {
        renderInlineText(for: node) // <-- builds one styled Text
            .font(theme.bodyFont(maxHeadingSize: maxHeadingSize))
    }
    
    func renderInlineText(for node: MarkdownNode) -> Text {
        switch node.type {
        case .text(let string):
            return Text(string)
        case .emphasis:
            return node.children.reduce(Text("")) { $0 + renderInlineText(for: $1).italic() }
        case .strong:
            return node.children.reduce(Text("")) { $0 + renderInlineText(for: $1).bold() }
            // ...add inline code, links, etc.
        default:
            return node.children.reduce(Text("")) { $0 + renderInlineText(for: $1) }
        }
    }
}
