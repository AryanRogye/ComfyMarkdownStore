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
    
    var body: some View {
        VStack {
            Group {
                if viewModel.isEditing {
                    editingView
                } else {
                    markdownView
                }
            }
            .padding(.top)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                toggleMarkdown
            }
            ToolbarItem(placement: .automatic) {
                fontSizePreview
            }
            ToolbarItem(placement: .navigation) {
                modalButton
            }
        }
        .sheet(isPresented: $viewModel.isSettingsOpen) {
            NavigationStack {
                SettingsView(viewModel: viewModel)
            }
        }
    }
    
    // MARK: - Toolbar Button
    private var toggleMarkdown: some View {
        Button(action: viewModel.toggleEditing) {
            Image(
                systemName: viewModel.isEditing
                ? "pencil"
                : "text.book.closed.fill"
            )
        }
    }
    private var fontSizePreview: some View {
        Text("\(viewModel.fontSize, specifier: "%.1f")")
            .font(.system(
                size: 20,
                weight: .regular,
                design: .monospaced
            ))
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .fixedSize()
    }
    private var modalButton : some View {
        Button(action: viewModel.toggleSettings) {
            Image(systemName: "gear")
        }
    }
    
    // MARK: - Editing View
    private var editingView: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 10) {
                CustomTextFieldWrapper(
                    textFieldText: $viewModel.text,
                    fontSize: $viewModel.fontSize,
                    isFocused: $viewModel.isFocused
                ) {
                    viewModel.onClose()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 32)
        }
    }
    
    // MARK: - Markdown View
    private var markdownView: some View {
        ComfyMarkdown(text: viewModel.text, maxFontSize: $viewModel.fontSize)
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var isEditing = false
        @Published var isFocused : Bool = false
        @Published var fontSize : CGFloat = 18.0
        @Published var isSettingsOpen : Bool = false
        @Published var text : String = """
        # Test
        ## TEST
        ### Test
        #### Test
        #### Test
        ##### Test
        ###### Test
            
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
            
        """
        
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
