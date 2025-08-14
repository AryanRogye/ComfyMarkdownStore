//
//  CodeBlock.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI

public struct CodeBlockView: View {
    // this is
    var literal: String?
    var info: String?
    
    @Environment(\.markdownTheme) private var theme
    @Environment(\.maxFontSize) private var maxHeadingSize

    public init(literal: String?, info: String?) {
        self.literal = literal
        self.info = info
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let info, !info.isEmpty {
                Text(info.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            if let literal, !literal.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    Text(literal)
                        .font(theme.codeBlockFont(maxHeadingSize: maxHeadingSize))
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(theme.codeBlockBackgroundColor)
                                .opacity(0.1)
                        )
                }
            }
        }
    }
}
