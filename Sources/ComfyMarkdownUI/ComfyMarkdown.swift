//
//  ComfyMarkdown.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI
import ComfyMarkdownCore
import Combine

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
    
    @StateObject private var viewModel : ViewModel
    @Binding var maxFontSize : CGFloat
    
    @Binding var text: String
    
    public init(text: String, maxFontSize: Binding<CGFloat> = .constant(18)) {
        self._maxFontSize = maxFontSize
        self._viewModel = .init(wrappedValue: ViewModel(text: text))
        self._text = .constant(text)
    }
    public init(text: Binding<String>, maxFontSize: Binding<CGFloat> = .constant(18)) {
        self._maxFontSize = maxFontSize
        self._viewModel = .init(wrappedValue: ViewModel(text: text.wrappedValue))
        self._text = text
    }
    
    
    public var body: some View {
        Group {
            if let error = viewModel.error {
                Text(error).foregroundStyle(.red)
            }
            else if let root = viewModel.root {
                RenderBlockListView(
                    nodes: root.children,
                    onToggleTaskItem: toggleTaskItem
                )
                .environment(\.maxFontSize, maxFontSize)
            } else {
                Text(viewModel.text)
                ProgressView()
            }
        }
        .onChange(of: maxFontSize) { _ in
            viewModel.handleParsingText()
        }
        .onChange(of: text) { value in
            viewModel.textPublisher.send(value)
        }
    }
    
    private func toggleTaskItem(_ node: MarkdownNode) {
        print("Toggled Task Item: \(node)")
        guard let updatedText = TaskMarkdownToggler.toggledMarkdown(text: text, node: node) else {
            return
        }
        
        text = updatedText
        viewModel.text = updatedText
        viewModel.handleParsingText()
    }
    
}

enum TaskMarkdownToggler {
    static func toggledMarkdown(text: String, node: MarkdownNode) -> String? {
        guard case .listItem(let checked) = node.type,
              let checked,
              let lineIndex = node.taskMarkerLineIndex else {
            return nil
        }
        
        var lines = text.components(separatedBy: "\n")
        guard lineIndex >= 0, lineIndex < lines.count else {
            return nil
        }
        
        let line = lines[lineIndex]
        guard let match = Self.taskMarkerRegex.firstMatch(
            in: line,
            range: NSRange(location: 0, length: (line as NSString).length)
        ) else {
            return nil
        }
        
        let nsLine = line as NSString
        let prefix = nsLine.substring(with: match.range(at: 1))
        let replacement = "\(prefix)[\(checked ? " " : "x")]"
        
        guard let markerRange = Range(match.range, in: line) else {
            return nil
        }
        
        lines[lineIndex].replaceSubrange(markerRange, with: replacement)
        return lines.joined(separator: "\n")
    }
    
    private static let taskMarkerRegex = try! NSRegularExpression(
        pattern: #"^(\s*(?:[-+*]|\d+[.)])\s+)\[[ xX]\]"#
    )
}

private extension MarkdownNode {
    var taskMarkerLineIndex: Int? {
        if let sourceRange {
            return sourceRange.startLine - 1
        }
        
        return children.lazy
            .compactMap(\.sourceRange)
            .map { $0.startLine - 1 }
            .first
    }
}

extension ComfyMarkdown {
    class ViewModel: ObservableObject {
        
        let textPublisher = PassthroughSubject<String, Never>()
        
        @Published var root : MarkdownNode?
        @Published var error: String?
        @Published var text: String
        @Published var updateCounter: Int = 0

        private var cancellables: Set<AnyCancellable> = []
        var cancellable: AnyCancellable?

        
        init(text: String) {
            self.text = text
            handleParsingText()
            
            textPublisher
                .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
                .sink { [weak self] newValue in
                    guard let self else { return }
                    self.text = newValue
                    self.handleParsingText()
                }
                .store(in: &cancellables)

        }
        
        let comfyMarkdownCore : ComfyMarkdownCore = ComfyMarkdownCore()
        
        public func showError(_ message: String) {
            error = message
        }
        
        public func handleParsingText() {
            do {
                /// Get Tree Of Markdown Node
                root = try comfyMarkdownCore.parse(markdown: text)
                error = nil
            }
            /// Error Handling
            catch let error as MarkdownASTError {
                switch error {
                case .invalidNode:
                    showError("Invalid Node")
                case .unsupportedNodeType(let type):
                    showError("Unsupported Node Type: \(type)")
                }
            }
            catch {
                showError("Error: \(error.localizedDescription)")
                print("There was a error: \(error.localizedDescription)")
            }
        }
    }
}
