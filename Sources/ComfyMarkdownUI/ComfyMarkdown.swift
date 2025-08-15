//
//  ComfyMarkdown.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI
import ComfyMarkdownCore

@MainActor
class DebugSettings: ObservableObject {
    static let shared = DebugSettings()
    @Published var showDebug = false
}

public struct DebugSwitcher<Content: View>: View {
    // Store as closure
    var content: () -> Content
    
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }
    
    public var body: some View {
        Button(action: {
            withAnimation(.interactiveSpring) {
                DebugSettings.shared.showDebug.toggle()
            }
        }) {
            content()
        }
    }
}

public struct ComfyMarkdown: View {
    
    @StateObject private var viewModel = ViewModel()
    @Binding var maxFontSize : CGFloat
    
    var text: String
    
    public init(text: String, maxFontSize: Binding<CGFloat> = .constant(18)) {
        self.text = text
        self._maxFontSize = maxFontSize
    }
    
    
    public var body: some View {
        Group {
            if let error = viewModel.error {
                Text(error).foregroundStyle(.red)
            }
            else if let root = viewModel.root {
                RenderBlockListView(nodes: root.children)
                    .environment(\.maxFontSize, maxFontSize)
            } else {
                Text(text)
                ProgressView()
            }
        }
        .task(id: text) {
            viewModel.handleParsingText(text)
        }
        .onChange(of: maxFontSize) { _ in
            viewModel.handleParsingText(text)
        }
    }
}

extension ComfyMarkdown {
    class ViewModel: ObservableObject {
        
        @Published var root : MarkdownNode?
        @Published var error: String?
        
        let comfyMarkdownCore : ComfyMarkdownCore = ComfyMarkdownCore()
        
        public func showError(_ message: String) {
            error = message
        }
        
        public func handleParsingText(_ text: String) {
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
}
