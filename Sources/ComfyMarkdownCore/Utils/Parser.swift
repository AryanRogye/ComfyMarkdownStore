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
    
    private var lastMarkdownNode: MarkdownNode?
    
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
    
    public func parse(_ markdown: String) throws -> MarkdownNode? {
        let normalizedMarkdown = normalizeIndentedOrderedLists(markdown)
        cmark_parser_feed(parser, normalizedMarkdown, normalizedMarkdown.utf8.count)
        let root = cmark_parser_finish(parser)
        
        guard let root = root else {
            print("Root Was Nil")
            return nil
        }
        
        let ast = try MarkdownAST.convertToSwiftNode(
            lastMarkdownNode: lastMarkdownNode,
            root: root
        )
        
        lastMarkdownNode = ast
        return ast
    }
    
    private func normalizeIndentedOrderedLists(_ markdown: String) -> String {
        let lines = markdown.components(separatedBy: "\n")
        var normalizedLines: [String] = []
        
        for line in lines {
            let shouldPromoteToNestedItem =
                line.range(of: #"^ {2}\d+[.)]\s+"#, options: .regularExpression) != nil &&
                normalizedLines.last { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.map { previousLine in
                    previousLine.range(of: #"^\d+[.)]\s+"#, options: .regularExpression) != nil ||
                    previousLine.range(of: #"^ {3}\d+[.)]\s+"#, options: .regularExpression) != nil
                } == true
            
            normalizedLines.append(shouldPromoteToNestedItem ? " \(line)" : line)
        }
        
        return normalizedLines.joined(separator: "\n")
    }
}
