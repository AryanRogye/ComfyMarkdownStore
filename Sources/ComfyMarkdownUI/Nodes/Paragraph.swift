//
//  Paragraph.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI
import ComfyMarkdownCore

public struct ParagraphView: View {
    var node : MarkdownNode
    
    @Environment(\.markdownTheme) private var theme
    @Environment(\.maxFontSize) private var maxHeadingSize
    
    public init(node: MarkdownNode) {
        self.node = node
    }
    
    public var body: some View {
        VStack {
            Text("Paragraph")
                .font(
                    theme.bodyFont(
                        maxHeadingSize: maxHeadingSize
                    )
                )
        }
    }
}
