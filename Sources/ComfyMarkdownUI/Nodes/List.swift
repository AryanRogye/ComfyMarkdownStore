//
//  List.swift
//  
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI
import ComfyMarkdownCore

public struct ListView: View {
    var delimiter: String?
    var ordered: Bool
    var start: Int
    var tight: Bool
    var node: MarkdownNode
    
    @Environment(\.markdownTheme) private var theme
    @Environment(\.maxFontSize) private var maxHeadingSize

    public init(delimiter: String? = nil, ordered: Bool, start: Int, tight: Bool, node: MarkdownNode) {
        self.delimiter = delimiter
        self.ordered = ordered
        self.start = start
        self.tight = tight
        self.node  = node
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: tight ? 2 : 8) {
            ForEach(Array(node.children.enumerated()), id: \.offset) { idx, child in
                HStack(
                    alignment: .firstTextBaseline,
                    spacing: 8
                ) {
                    Text(ordered ? "\(start + idx)." : "•")
                        .font(
                            theme.bodyFont(
                                maxHeadingSize: maxHeadingSize
                            )
                        )
                        .frame(alignment: .leading)
                    
                    RenderNodeView(
                        node: child
                    )
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
            }
        }
    }
}
