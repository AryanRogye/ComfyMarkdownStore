//
//  ComfyMarkdownCore.swift
//  ComfyMarkdownCore
//
//  Created by Aryan Rogye on 8/13/25.
//

import Foundation

/// Plan
//[Raw Markdown String]
//│
//▼
//MarkdownParser (Swift class)
//│  - init() attaches all GFM extensions
//│  - wraps a cmark_parser*
//▼
//[libcmark-gfm C parser]
//│
//▼
//[cmark_node* AST Root]
//│
//├── render HTML/plaintext/LaTeX (via cmark_render_...)
//│
//└── traverse AST (via cmark_iter_* APIs)


public class ComfyMarkdownCore {
    let parser : Parser
    
    public init() {
        parser = Parser()
    }
    
    public func parse(markdown: String) throws -> MarkdownNode? {
        try parser.parse(markdown)
    }
}

