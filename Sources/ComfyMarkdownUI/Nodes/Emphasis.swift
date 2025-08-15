//
//  Emphasis.swift
//
//
//  Created by Aryan Rogye on 8/14/25.
//

import SwiftUI
import ComfyMarkdownCore

struct EmphasisView: View {
    var node: MarkdownNode
    
    public init(node: MarkdownNode) {
        self.node = node
    }
    
    public var body: some View {
        Text(node.plainText)
            .italic()
    }
}
