//
//  ComfyMarkdown.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI
import ComfyMarkdownCore

extension ComfyMarkdown {
    class ViewModel: ObservableObject {
        
    }
}

public extension View {
    func markdownTheme(_ theme: MarkdownTheme) -> some View {
        environment(\.markdownTheme, theme)
    }
}

@MainActor
public struct MarkdownTheme {
    
    public var bodyFontSize: CGFloat = 16
    public var headingRatios: [CGFloat] = [1.00, 0.85, 0.75, 0.65, 0.55, 0.50]
    
    public func headingFont(for level: Int, maxHeadingSize: CGFloat) -> Font {
        let idx = max(1, min(6, level)) - 1
        let size = maxHeadingSize * headingRatios[idx]
        let weight: Font.Weight = (level == 1) ? .bold : .semibold
        return .system(size: size, weight: weight)
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

public struct ComfyMarkdown: View {
    
    let comfyMarkdownCore : ComfyMarkdownCore = ComfyMarkdownCore()
    
    @State var error: String?
    @State var root : MarkdownNode?
    @Binding var maxFontSize : CGFloat
    
    var text: String

    public init(text: String, maxFontSize: Binding<CGFloat> = .constant(18)) {
        self.text = text
        self._maxFontSize = maxFontSize
    }
    
    private func showError(_ message: String) {
        error = message
    }
    
    public var body: some View {
        Group {
            if let error = error {
                Text(error).foregroundStyle(.red)
            } else if let root {
                RenderBlockListView(nodes: root.children)
                    .environment(\.maxFontSize, maxFontSize)
            } else {
                Text(text)
                ProgressView()
            }
        }
        .task(id: text) {
            handleParsingText(text)
        }
        .onChange(of: maxFontSize) { _ in
            handleParsingText(text)
        }
    }
    
    private func handleParsingText(_ text: String) {
        do {
            /// Get Tree Of Markdown Node
            root = try comfyMarkdownCore.parse(markdown: text)
            error = nil
        }
        /// Error Handling
        catch {
            showError("Error: \(error.localizedDescription)")
        }
        catch let error as MarkdownASTError {
            switch error {
            case .invalidNode:
                showError("Invalid Node")
            case .unsupportedNodeType(let type):
                showError("Unsupported Node Type: \(type)")
            }
        }
    }
}
