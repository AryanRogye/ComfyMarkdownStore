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
    
    @ObservedObject var debugSettings = DebugSettings.shared
    
    public init(node: MarkdownNode) {
        self.node = node
    }
    
    public var body: some View {
        VStack {
#if DEBUG
            if debugSettings.showDebug {
                HStack(spacing: 4) {
                    ForEach(node.children, id: \.self) { child in
                        Text(child.type.label)
                            .font(.caption2)
                            .padding(2)
                            .background(Color.yellow.opacity(0.3))
                    }
                }
            }
#endif
            renderInlineText(for: node) // <-- builds one styled Text
                .font(theme.bodyFont(maxHeadingSize: maxHeadingSize))
        }
#if DEBUG
        .border(Color.black, width: debugSettings.showDebug ? 1 : 0)
#endif

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
