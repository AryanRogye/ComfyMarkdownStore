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
    var onToggleTaskItem: ((MarkdownNode) -> Void)?
    
    @Environment(\.markdownTheme) private var theme
    @Environment(\.maxFontSize) private var maxHeadingSize

    public init(
        delimiter: String? = nil,
        ordered: Bool,
        start: Int,
        tight: Bool,
        node: MarkdownNode,
        onToggleTaskItem: ((MarkdownNode) -> Void)? = nil
    ) {
        self.delimiter = delimiter
        self.ordered = ordered
        self.start = start
        self.tight = tight
        self.node  = node
        self.onToggleTaskItem = onToggleTaskItem
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: tight ? 2 : 8) {
            ForEach(Array(node.children.enumerated()), id: \.offset) { idx, child in
                HStack(
                    alignment: .firstTextBaseline,
                    spacing: 8
                ) {
                    markerView(for: child, at: idx)
                    
                    RenderNodeView(
                        node: child,
                        onToggleTaskItem: onToggleTaskItem
                    )
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    if child.isTaskListItem {
                        onToggleTaskItem?(child)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func markerView(for node: MarkdownNode, at index: Int) -> some View {
        if case .listItem(let checked) = node.type, let checked {
            Image(systemName: checked ? "checkmark.square.fill" : "square")
                .font(theme.bodyFont(maxHeadingSize: maxHeadingSize))
                .foregroundColor(checked ? .accentColor : .secondary)
                .frame(width: 20, alignment: .leading)
            .accessibilityLabel(checked ? "Checked" : "Unchecked")
        } else {
            Text(ordered ? "\(start + index)." : "•")
                .font(
                    theme.bodyFont(
                        maxHeadingSize: maxHeadingSize
                    )
                )
                .frame(alignment: .leading)
        }
    }
}

private extension MarkdownNode {
    var isTaskListItem: Bool {
        if case .listItem(let checked) = type {
            return checked != nil
        }
        return false
    }
}
