//
//  Parser.swift
//  ComfyMarkdownCore
//
//  Created by Aryan Rogye on 8/13/25.
//

import cmark_gfm
import cmark_gfm_extensions

public class Parser {
    let parser : UnsafeMutablePointer<cmark_parser>
    
    public init() {
        /// Create a parser with default options
        parser = cmark_parser_new_with_mem(CMARK_OPT_DEFAULT, cmark_get_default_mem_allocator())        /// Configure the parser extensions
        self.configureExtensions()
    }
    
    deinit {
        cmark_parser_free(parser)
    }
    
    // MARK: -  Configure Extensions
    private func configureExtensions() {
        cmark_gfm_core_extensions_ensure_registered()
        
        let names = ["table", "autolink", "strikethrough", "tasklist", "tagfilter", "footnotes"]
        for name in names {
            if let ext = cmark_find_syntax_extension(name) {
                cmark_parser_attach_syntax_extension(parser, ext)
            }
        }
    }
    
    // Since idk much about this gonna leave this empty return for now
    public func parse(_ markdown: String) throws -> MarkdownNode? {
        cmark_parser_feed(parser, markdown, markdown.utf8.count)
        let root = cmark_parser_finish(parser)
        let ast = MarkdownAST(root: root)
        return try ast.convertToSwiftNode()
    }
}
