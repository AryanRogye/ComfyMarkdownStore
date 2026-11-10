//
//  MarkdownNode.swift
//  ComfyMarkdownCore
//
//  Created by Aryan Rogye on 8/13/25.
//

import Foundation

public struct MarkdownSourceRange: Hashable, Equatable {
    public var startLine: Int
    public var startColumn: Int
    public var endLine: Int
    public var endColumn: Int
    
    public init(startLine: Int, startColumn: Int, endLine: Int, endColumn: Int) {
        self.startLine = startLine
        self.startColumn = startColumn
        self.endLine = endLine
        self.endColumn = endColumn
    }
}

/// Tree structure representing a Markdown document.
public struct MarkdownNode: Identifiable, Hashable, Equatable {
    public let id: UUID = UUID()
    public var type: MarkdownNodeType
    public var children: [MarkdownNode] = []
    public var sourceRange: MarkdownSourceRange?
    
    public init(
        type: MarkdownNodeType,
        children: [MarkdownNode] = [],
        sourceRange: MarkdownSourceRange? = nil
    ) {
        self.type = type
        self.children = children
        self.sourceRange = sourceRange
    }
    
    public func child(at index: Int) -> MarkdownNode? {
        guard index >= 0 && index < children.count else { return nil }
        return children[index]
    }
    
    /// Function To Nicely Visualize Markdown
    public func visualizeAST(indentation: String = "") {
        // Print current node type
        print("\(indentation)- \(type.description)")
        
        // Print children recursively, indented
        for child in children {
            child.visualizeAST(indentation: indentation + "  ")
        }
    }
    
    public var plainText: String {
        switch type {
        case .text(let s):
            return s
        case .softBreak:
            return " "
        case .lineBreak:
            return "\n"
        default:
            return children.map { $0.plainText }.joined()
        }
    }
}
