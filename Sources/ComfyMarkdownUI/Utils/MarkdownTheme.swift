//
//  MarkdownTheme.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI

@MainActor
public struct MarkdownTheme {
    
    public var headingRatios: [CGFloat] = [1.00, 0.85, 0.75, 0.65, 0.55, 0.50]
    public var bodyRatio: CGFloat = 0.6
    public var dividerColor: Color = .secondary
    
    public func headingFont(for level: Int, maxHeadingSize: CGFloat) -> Font {
        let idx = max(1, min(6, level)) - 1
        let size = maxHeadingSize * headingRatios[idx]
        let weight: Font.Weight = (level == 1) ? .bold : .semibold
        return .system(size: size, weight: weight)
    }
    
    public func bodyFont(maxHeadingSize: CGFloat) -> Font {
        .system(size: maxHeadingSize * bodyRatio)
    }
}

private struct MarkdownThemeKey: EnvironmentKey {
    static let defaultValue = MarkdownTheme()
}

public extension EnvironmentValues {
    var markdownTheme: MarkdownTheme {
        get { self[MarkdownThemeKey.self] }
        set { self[MarkdownThemeKey.self] = newValue }
    }
}

private struct MaxFontSizeKey: EnvironmentKey {
    static let defaultValue: CGFloat = 18 // default max H1 size in points
}

public extension EnvironmentValues {
    var maxFontSize: CGFloat {
        get { self[MaxFontSizeKey.self] }
        set { self[MaxFontSizeKey.self] = newValue }
    }
}

public extension View {
    func markdownTheme(_ theme: MarkdownTheme) -> some View {
        environment(\.markdownTheme, theme)
    }
}
