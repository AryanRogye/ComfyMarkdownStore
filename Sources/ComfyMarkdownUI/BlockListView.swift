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
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(nodes) { node in
                    RenderNodeView(node: node)
                }
            }
            .padding(.horizontal)
        }
    }
}

public struct RenderNodeView: View {
    let node: MarkdownNode
    
    @ObservedObject var debugSettings = DebugSettings.shared
    
    @ViewBuilder
    public var body: some View {
        VStack {
#if DEBUG
            if debugSettings.showDebug {
                Text(node.type.label)
            }
#endif
            switch node.type {
            case .heading(let level):                                   HeadingView(level: level, node: node)
            case .paragraph:                                            ParagraphView(node: node)
            case .thematicBreak:                                        ThematicBreakView()
            case .blockQuote:                                           BlockquoteView(node: node)
            case .codeBlock(let info, let literal):                     CodeBlockView(literal: literal, info: info)
            case .list(let ordered,let start,let tight,let delimiter):  ListView(delimiter: delimiter, ordered: ordered, start: start, tight: tight, node: node)
            case .listItem:                                             ListItemView(node: node)
            case .emphasis:                                             EmphasisView(node: node)
            case .strong  :                                             StrongView(node: node)
                
            case .htmlBlock(let literal):                                HTMLBlockView(literal: literal)
            case .htmlInline(let literal):                               HTMLInlineView(literal: literal)
                
            case .text(let text):                                       Text(text)
            default:                                                    EmptyView()
                
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
#if DEBUG
        .border(Color.black, width: debugSettings.showDebug ? 1 : 0)
#endif
    }
}
