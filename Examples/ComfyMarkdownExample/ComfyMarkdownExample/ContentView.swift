//
//  ContentView.swift
//  ComfyMarkdownExample
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI
import ComfyMarkdownUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    @StateObject private var markdownDocManager = MarkdownDocManager()
    
    var body: some View {
        VStack(spacing: 0) {
            if let doc = viewModel.clickedDoc {
                activeDocHeader(doc: doc)
            }
            
            ZStack {
                if viewModel.isEditing {
                    editingView
                        .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                } else {
                    markdownView
                        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .trailing).combined(with: .opacity)))
                }
            }
            .animation(AppAnim.modeSwitch, value: viewModel.isEditing)
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                toggleMarkdown
                if viewModel.clickedDoc != nil {
                    saveButton
                }
            }
            
            ToolbarItemGroup(placement: .navigation) {
                storedButton
                fontSizePreview
            }
            
            ToolbarItemGroup(placement: .automatic) {
                debugSwitcher
                modalButton
            }
        }
        .sheet(isPresented: $viewModel.isSettingsOpen) {
            NavigationStack {
                SettingsView(viewModel: viewModel)
            }
        }
        .sheet(isPresented: $viewModel.shouldShowStored) {
            Stored(markdownDocManager, clickedDoc: { doc, content in
                withAnimation(AppAnim.snap) {
                    viewModel.clickedDoc = doc
                    viewModel.text = content
                    viewModel.shouldShowStored = false
                }
            })
        }
    }
    
    private func activeDocHeader(doc: MarkdownDoc) -> some View {
        HStack {
            Image(systemName: "doc.text.fill")
                .foregroundColor(.blue)
            Text(doc.title)
                .font(.headline)
            Spacer()
            Text("Last saved: \(doc.updatedAt.formatted(date: .omitted, time: .shortened))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color(NSColor.windowBackgroundColor))
        .overlay(Divider(), alignment: .bottom)
    }
    
    // MARK: - Toolbar Button
    private var saveButton: some View {
        Button(action: {
            if let doc = viewModel.clickedDoc {
                markdownDocManager.saveContent(for: doc, with: viewModel.text)
                #if os(iOS)
                Haptics.success()
                #endif
            }
        }) {
            Label("Save", systemImage: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
        .help("Save Changes")
    }
    
    private var storedButton: some View {
        Button(action: {
            viewModel.shouldShowStored = true
        }) {
            Label("Documents", systemImage: "folder.fill")
        }
        .help("Your Documents")
    }
    
    private var toggleMarkdown: some View {
        Button(action: viewModel.toggleEditing) {
            Label(
                viewModel.isEditing ? "View" : "Edit",
                systemImage: viewModel.isEditing ? "eye.fill" : "pencil.circle.fill"
            )
        }
        .help(viewModel.isEditing ? "Switch to Preview" : "Switch to Editor")
    }
    
    private var fontSizePreview: some View {
        HStack(spacing: 4) {
            Image(systemName: "textformat.size")
                .font(.caption)
            Text("\(Int(viewModel.fontSize))")
                .font(.system(.body, design: .monospaced))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var modalButton : some View {
        Button(action: viewModel.toggleSettings) {
            Image(systemName: "slider.horizontal.3")
        }
        .help("Settings")
    }
    
    private var debugSwitcher: some View {
        DebugSwitcher {
            Image(systemName: "ant.fill")
                .foregroundColor(DebugSettings.shared.showDebug ? .orange : .secondary)
        }
        .help("Toggle Debug Mode")
    }
    
    // MARK: - Editing View
    private var editingView: some View {
        VStack(spacing: 0) {
#if os(iOS)
            CustomTextFieldWrapper(
                textFieldText: $viewModel.text,
                fontSize: $viewModel.fontSize,
                isFocused: $viewModel.isFocused
            ) {
                viewModel.onClose()
            }
#else
            TextEditor(text: $viewModel.text)
                .font(.system(size: viewModel.fontSize, design: .monospaced))
                .padding(24)
                .scrollContentBackground(.hidden)
                .background(Color(NSColor.textBackgroundColor))
#endif
        }
    }
    
    // MARK: - Markdown View
    private var markdownView: some View {
        ScrollView {
            ComfyMarkdown(text: viewModel.text, maxFontSize: $viewModel.fontSize)
                .padding(24)
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        
        @Published var clickedDoc: MarkdownDoc? = nil
        @Published var shouldShowStored = false
        @Published var isEditing = false
        @Published var isFocused : Bool = false
        @Published var fontSize : CGFloat = 18.0
        @Published var isSettingsOpen : Bool = false
        let defaultText: String = """
        # Test
        ## TEST
        ### Test
        #### Test
        #### Test
        ##### Test
        ###### Test
        
        [THIS IS A EXAMPLE](https://canvas.uic.edu/courses/30691)
            
        ---
            
        This is a paragraph.
        It can span multiple lines in the source file,  
        and Markdown will wrap it together when rendered.
            
        ***
            
        This is a second paragraph, because it’s separated by a blank line.
            
        ---
            
        > This is a BlockQuoteView
        > With Another one
            
        > Testing With Detached
        > Lines in between
            
        ---
            
        ```swift
            let test = Test()
        ```
            
        ---
            
        - # Item 1
            - Item 2
            - item 3
        - ## item 2
            - item 3
        - ## Item 4
            - Item 5
                - #### item 6
        
        ---
        
        ## *This* is a emphasized *Text*
        **This** is a bold **Text**
        
        **THIS IS BOLD**
            
        """
        
        @Published var text : String
        
        init() {
            self.text = defaultText
        }
        
        @MainActor
        public func onClose() {
            if isFocused {
                /// Hide the Keyboard
                isFocused = false
                Keyboard.hide()
            }
        }
        
        @MainActor
        public func toggleEditing() {
            withAnimation(AppAnim.modeSwitch) {
                isEditing.toggle()
            }
        }
        
        @MainActor
        public func toggleSettings() {
            // Placeholder for settings action
            withAnimation(AppAnim.modeSwitch) {
                isSettingsOpen.toggle()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
