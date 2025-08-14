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

extension ComfyMarkdown {
    func setMaxFontSize(_ font: CGFloat) -> Self {
        var copy = self
        copy.maxFontSize = font
        return copy
    }
}

public struct ComfyMarkdown: View {
    
    let comfyMarkdownCore : ComfyMarkdownCore = ComfyMarkdownCore()
    
    @State var error: String?
    @State var root : MarkdownNode?
    @State var maxFontSize: CGFloat = 17
    
    var text: String

    public init(text: String) {
        self.text = text
    }
    
    private func showError(_ message: String) {
        error = message
    }
    
    public var body: some View {
        Group {
            if let error = error {
                Text(error).foregroundStyle(.red)
            } else if let root {
                /// impliment to show root
                RenderBlockListView(nodes: root.children)
            } else {
                Text(text)
                ProgressView()
            }
        }
        .task(id: text) {
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
