//
//  ThematicBreak.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI

public struct ThematicBreakView: View {
    
    @Environment(\.markdownTheme) private var theme
    
    public init() {}
    
    public var body: some View {
        Divider()
            .padding(.vertical, 8)
            .foregroundStyle(theme.dividerColor)
            .frame(height: 1)
    }
}
