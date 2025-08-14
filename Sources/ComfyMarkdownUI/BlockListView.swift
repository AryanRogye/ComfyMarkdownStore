//
//  BlockListView.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI
import ComfyMarkdownCore

public struct RenderBlockListView: View {
    var nodes: [MarkdownNode]
    
    public init(nodes: [MarkdownNode]) {
        self.nodes = nodes
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(nodes.enumerated()), id: \.offset) { _, node in
                RenderNodeView(node: node)
            }
        }
    }
}

public struct RenderNodeView: View {
    let node: MarkdownNode
    
    @ViewBuilder
    public var body: some View {
        switch node.type {
        case .heading(let level):   HeadingView(level: level, node: node)
        case .paragraph:            ParagraphView(node: node)
        default:                    EmptyView()

            //        case .blockquote, .blockQuote:
            //            BlockquoteView(node: node)
            //
            //        case .thematicBreak:
            //            Divider().padding(.vertical, 8)
            //
            //        case .list(let ordered, let start, let tight, _),
            ////            ListBlockView(node: node, ordered: ordered, start: start, tight: tight)
            //
            //        .codeBlock(_, let code),
            ////            CodeBlockView(code: code)
            //
            //            // Inline nodes will be handled inside Paragraph/Heading
            //        .text, .emphasis, .strong, .link, .image, .code,
            //                .softBreak, .lineBreak, .htmlInline, .customInline,
            //            // If these appear as top-level (rare), show as paragraph fallback
            ////            ParagraphView(node: node)
            //
            //            // Table / footnotes / custom blocks -> ignore for now or add later
            //        .table, .table_header, .tableRow, .tableCell, .footnoteDefinition,
            //                .footnoteReference, .htmlBlock, .customBlock, .attribute, .none, .document:
            //            EmptyView()
        }
    }
}
