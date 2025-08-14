//
//  MarkdownNode.swift
//  ComfyMarkdownCore
//
//  Created by Aryan Rogye on 8/13/25.
//

import Foundation

/// Tree structure representing a Markdown document.
public struct MarkdownNode: Identifiable {
    public let id: UUID = UUID()
    public var type: MarkdownNodeType
    public var children: [MarkdownNode] = []
    
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
