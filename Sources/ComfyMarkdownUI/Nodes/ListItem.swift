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
    var onToggleTaskItem: ((MarkdownNode) -> Void)?
    
    public init(
        node: MarkdownNode,
        onToggleTaskItem: ((MarkdownNode) -> Void)? = nil
    ) {
        self.node = node
        self.onToggleTaskItem = onToggleTaskItem
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(node.children) { child in
                RenderNodeView(
                    node: child,
                    onToggleTaskItem: onToggleTaskItem
                )
            }
        }
    }
}
