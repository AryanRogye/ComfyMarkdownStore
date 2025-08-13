//
//  MarkdownNode.swift
//  ComfyMarkdownCore
//
//  Created by Aryan Rogye on 8/13/25.
//


/// Tree structure representing a Markdown document.
struct MarkdownNode {
    var type: MarkdownNodeType
    var children: [MarkdownNode] = []
    
    public func visualizeAST(indentation: String = "") {
        // Print current node type
        print("\(indentation)- \(type.description)")
        
        // Print children recursively, indented
        for child in children {
            child.visualizeAST(indentation: indentation + "  ")
        }
    }
}
