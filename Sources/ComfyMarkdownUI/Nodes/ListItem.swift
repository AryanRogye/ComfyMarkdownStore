//
//  ListItem.swift
//
//
//  Created by Aryan Rogye on 8/14/25.
//

import SwiftUI
import ComfyMarkdownCore

public struct ListItemView: View {
    var node: MarkdownNode
    
    public init(node: MarkdownNode) {
        self.node = node
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(node.children) { child in
                RenderNodeView(node: child)
            }
        }
    }
}
