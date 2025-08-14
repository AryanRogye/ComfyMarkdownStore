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
    
    public init(level: Int, node: MarkdownNode) {
        self.level = level
        self.node = node
    }
    
    public var body: some View {
        VStack {
            Text("Heading")
        }
    }
}
