//
//  MarkdownAST.swift
//  ComfyMarkdownCore
//
//  Created by Aryan Rogye on 8/13/25.
//

import cmark_gfm
import cmark_gfm_extensions

/*
 ==============================================================
 // If For Example Markdown Looked Like:
 ==============================================================
 //   # Title
 //
 //   Hello *world*
 ==============================================================
 // Then The cmark_node will internally in memory look like:
 ==============================================================
 // (document)
 // └── (heading level=1)
 //     └── (text) "Title"
 // └── (paragraph)
 //     ├── (text) "Hello "
 //     └── (emphasis)
 //         └── (text) "world"
 ==============================================================
 How to traverse:
 ==============================================================
 // var node = cmark_node_first_child(root)
 // while node != nil {
 //     let type = cmark_node_get_type(node)
 //     let literal = cmark_node_get_literal(node)
 //     node = cmark_node_next(node)
 // }
 // - `cmark_node_first_child(node)` → first child
 // - `cmark_node_next(node)` → next sibling
 // - `cmark_node_parent(node)` → go up
 // - Only modify nodes after EXIT events if using iterators
 ==============================================================
 The Goal is Getting a Swift AST Representation
 ==============================================================
 // `Models/MarkdownNode.swift` is our Swift representation of the Markdown AST.
 */


public enum MarkdownASTError: Error, Equatable {
    case invalidNode
    case unsupportedNodeType(type: String? = nil)
}

public struct MarkdownAST {
    /// cmake_node is a tree structure representing the Markdown document.
    var root: UnsafeMutablePointer<cmark_node>? = nil
    
    init(root: UnsafeMutablePointer<cmark_node>?) {
        self.root = root
        
        /// We will need to walk/transform the AST in Swift
    }
    
    // MARK: - Public API To Convert To Swift Node
    public func convertToSwiftNode() throws -> MarkdownNode? {
        guard let root = root else {
            throw MarkdownASTError.invalidNode
        }
        return try convertNode(root)
    }
    
    // MARK: - Private Helper Methods
    
    /// function to convert a cmark_node to a MarkdownNode
    private func convertNode(
        _ node: UnsafeMutablePointer<cmark_node>
    ) throws -> MarkdownNode? {
        
        /// Get The Swift Type
        guard let swiftType = mapType(cmark_node_get_type(node), node) else {
            throw MarkdownASTError.unsupportedNodeType(type: String(cString: cmark_node_get_type_string(node)))
        }
        
        var children: [MarkdownNode] = []
        
        var child = cmark_node_first_child(node)
        while let c = child {
            if let swiftChild = try convertNode(c) {
                children.append(swiftChild)
            }
            child = cmark_node_next(c)
        }
        
        return MarkdownNode(type: swiftType, children: children)
    }
}

// MARK: - Mapping Logic
extension MarkdownAST {
    private func mapType(
        _ type: cmark_node_type,
        _ node: UnsafeMutablePointer<cmark_node>
    ) -> MarkdownNodeType? {
        
        /// for the tables
        let typeString = String(cString: cmark_node_get_type_string(node))
        switch type {
            // ==== Implemented cases ====
        case CMARK_NODE_DOCUMENT:
            return .document
            
        case CMARK_NODE_PARAGRAPH:
            return .paragraph
            
        case CMARK_NODE_HEADING:
            let level = cmark_node_get_heading_level(node)
            return .heading(level: Int(level))
            
        case CMARK_NODE_TEXT:
            if let literal = cmark_node_get_literal(node) {
                return .text(String(cString: literal))
            }
            return .text("")
            
        case CMARK_NODE_BLOCK_QUOTE:
            return .blockQuote
            
        case CMARK_NODE_LIST:
            let ordered = cmark_node_get_list_type(node) == CMARK_ORDERED_LIST
            let startRaw = Int(cmark_node_get_list_start(node))
            let start = startRaw == 0 ? 1 : startRaw
            let tight = cmark_node_get_list_tight(node) != 0
            let delim: String?
            switch cmark_node_get_list_delim(node) {
            case CMARK_PERIOD_DELIM: delim = "."
            case CMARK_PAREN_DELIM: delim = ")"
            default: delim = nil
            }
            return .list(ordered: ordered, start: start, tight: tight, delimiter: delim)
            
        case CMARK_NODE_ITEM:
            return .listItem
            
        case CMARK_NODE_CODE_BLOCK:
            let info = cmark_node_get_fence_info(node).flatMap { String(cString: $0) }
            var literal = cmark_node_get_literal(node).flatMap { String(cString: $0) } ?? ""
            if literal.hasSuffix("\n") {
                literal.removeLast()
            }
            return .codeBlock(info: info?.isEmpty == true ? nil : info, literal: literal)
            
        case CMARK_NODE_HTML_BLOCK:
            if let html = cmark_node_get_literal(node) {
                return .htmlBlock(String(cString: html))
            }
            return .htmlBlock("")
            
        case CMARK_NODE_CUSTOM_BLOCK:
            let onEnter = cmark_node_get_on_enter(node).flatMap { String(cString: $0) }
            let onExit = cmark_node_get_on_exit(node).flatMap { String(cString: $0) }
            return .customBlock(onEnter: onEnter, onExit: onExit)
            
        case CMARK_NODE_THEMATIC_BREAK:
            return .thematicBreak
            
        case CMARK_NODE_FOOTNOTE_DEFINITION:
            return .footnoteDefinition
            
        case CMARK_NODE_SOFTBREAK:
            return .softBreak
            
        case CMARK_NODE_LINEBREAK:
            return .lineBreak
            
        case CMARK_NODE_CODE:
            if let literal = cmark_node_get_literal(node) {
                return .code(String(cString: literal))
            }
            return .code("")
            
        case CMARK_NODE_HTML_INLINE:
            if let html = cmark_node_get_literal(node) {
                return .htmlInline(String(cString: html))
            }
            return .htmlInline("")
            
        case CMARK_NODE_CUSTOM_INLINE:
            let onEnter = cmark_node_get_on_enter(node).flatMap { String(cString: $0) }
            let onExit = cmark_node_get_on_exit(node).flatMap { String(cString: $0) }
            return .customInline(onEnter: onEnter, onExit: onExit)
            
        case CMARK_NODE_EMPH:
            return .emphasis
            
        case CMARK_NODE_STRONG:
            return .strong
            
        case CMARK_NODE_LINK:
            /// More Saftey so that no Nil returns
            let urlCString = cmark_node_get_url(node)
            let url = urlCString.flatMap {
                let str = String(cString: $0)
                return str.isEmpty ? nil : str
            }
            
            let titleCString = cmark_node_get_title(node)
            let title = titleCString.flatMap {
                let str = String(cString: $0)
                return str.isEmpty ? nil : str
            }
            
            return .link(url: url ?? "", title: title)
            
        case CMARK_NODE_IMAGE:
            let urlCString = cmark_node_get_url(node)
            let url = urlCString.flatMap {
                let str = String(cString: $0)
                return str.isEmpty ? nil : str
            }
            
            let titleCString = cmark_node_get_title(node)
            let title = titleCString.flatMap {
                let str = String(cString: $0)
                return str.isEmpty ? nil : str
            }
            
            return .image(url: url ?? "", title: title)
            
        case CMARK_NODE_FOOTNOTE_REFERENCE:
            return .footnoteReference
            
        case CMARK_NODE_ATTRIBUTE:
            return .attribute
            
        case CMARK_NODE_NONE:
            return MarkdownNodeType.none
        default:
            break
        }
        
        switch typeString {
        case "table":
            return .table
        case "table_header":
            return .table_header
        case "table_row":
            // TODO: When swift-cmark exposes cmark_node_get_table_row_is_header, use it
            return .tableRow(header: false)
        case "table_cell":
            // TODO: When swift-cmark exposes cmark_node_get_table_cell_alignment, use it
            return .tableCell(align: nil)
        default:
            return nil
        }

    }
}
