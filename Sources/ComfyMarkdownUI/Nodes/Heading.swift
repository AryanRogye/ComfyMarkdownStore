//
//  Heading.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/13/25.
//

//HeadingView(level: level, node: node)

import SwiftUI
import ComfyMarkdownCore

public struct HeadingView: View {
    
    var level: Int
    var node : MarkdownNode
    
    @Environment(\.markdownTheme) private var theme
    @Environment(\.maxFontSize) private var maxHeadingSize
    
    @State private var text: String?
    
    public init(level: Int, node: MarkdownNode) {
        self.level = level
        self.node  = node
    }
    
    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            ForEach(node.children, id: \.self) { child in
                RenderNodeView(node: child)
            }
        }
        .font(
            theme.headingFont(
                for: level,
                maxHeadingSize: maxHeadingSize
            )
        )
    }
}
