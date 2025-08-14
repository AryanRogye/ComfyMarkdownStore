//
//  Builder.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/13/25.
//

import Foundation

public struct Builder {
    public static func build(from node: MarkdownNode) -> AttributedString {
        build(from: node.children)
    }
    public static func build(from nodes: [MarkdownNode]) -> AttributedString {
        var out = AttributedString()
//        out.unicodeScalars.reserveCapacity(estimateSize(nodes))
        append(nodes, into: &out)
        return out
    }
    
    public static func append(
        _ nodes: [MarkdownNode],
        into out: inout AttributedString
    ) {
        for child in nodes {
            switch child.type {
                // ── Plain text ──────────────────────────────────────────────
            case .text(let literal):
                out.append(AttributedString(literal))
                
                // ── Soft & hard breaks ──────────────────────────────────────
            case .softBreak:
                out.append(AttributedString(" "))
            case .lineBreak:
                out.append(AttributedString("\n"))
                
                // ── Emphasis / Strong (no font here; let the container decide size)
            case .emphasis:
                var a = build(from: child.children)
                a.inlinePresentationIntent = .emphasized
                out.append(a)
                
            case .strong:
                var a = build(from: child.children)
                a.inlinePresentationIntent = .stronglyEmphasized
                out.append(a)
                
                // ── Inline code: give it a mono font (override container font)
            case .code(let literal):
                var a = AttributedString(literal)
                out.append(a)
                
                // ── Link: set URL on the run; styling can be via environment
            case .link(let urlString, _):
                var a = build(from: child.children)
                if let url = URL(string: urlString), !urlString.isEmpty {
                    a.link = url
                }
                out.append(a)
                
                // ── Image: not inline text; skip here and render as its own View in block renderer
            case .image:
                break
                
                // ── Blocks that shouldn't appear at inline level (ignore here)
            case .paragraph, .heading, .list,
                    .listItem, .blockQuote, .codeBlock,
                    .thematicBreak, .htmlInline, .htmlBlock,
                    .customInline, .customBlock, .footnoteReference,
                    .footnoteDefinition, .attribute, .document,
                    .table, .table_header, .tableRow, .tableCell,
                    .none:
                // These are either block-level or unsupported as inline text.
                // Handle in your block renderer instead.
                break
            }
        }
    }
}
