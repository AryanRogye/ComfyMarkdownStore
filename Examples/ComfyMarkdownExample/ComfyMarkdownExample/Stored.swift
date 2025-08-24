//
//  Stored.swift
//  ComfyMarkdownExample
//
//  Created by Aryan Rogye on 8/24/25.
//

import SwiftUI

extension Stored {
    class ViewModel: ObservableObject {
        @Published var text: String = ""
        let defaults : UserDefaults = .standard
    }
}

struct Stored: View {
    
    @State private var isPresented: Bool = false
    @StateObject private var viewModel: ViewModel = ViewModel()
    
    @ObservedObject var markdownDocManager: MarkdownDocManager
    
    private var clickedDoc: (MarkdownDoc, String) -> Void
    
    init(
        _ markdownDocManager: MarkdownDocManager,
        clickedDoc : @escaping (MarkdownDoc, String) -> Void
    ) {
        self.markdownDocManager = markdownDocManager
        self.clickedDoc = clickedDoc
    }
    
    var body: some View {
        VStack {
            ///  Show List Of All
            emptyView
                .padding()
            
            list
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var list: some View {
        VStack(alignment: .leading) {
            Text("Your List Goes Here")
                .font(.headline)
                .frame(alignment: .leading)
                .padding(.horizontal)
            
            Divider()
            ScrollView {
                ForEach(markdownDocManager.docs, id: \.self) { doc in
                    
                    Button(action: {
                        let content = markdownDocManager.loadContent(for: doc)
                        clickedDoc(doc, content)
                    }) {
                        listView(doc)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func listView(_ doc: MarkdownDoc) -> some View {
        HStack {
            Text(doc.title)
            
            Spacer()
            
            VStack {
                Text("Created: \(doc.createdAt.formatted())")
                    .font(.caption)
                Text("Updated: \(doc.updatedAt.formatted())")
                    .font(.caption)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.1))
        }
    }
    
    private var emptyView: some View {
        HStack {
            TextField("New Markdown", text: $viewModel.text)
                .frame(maxHeight: .infinity)
                .padding(.leading)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.1))
                }
            
            Button(action: {
                if !viewModel.text.isEmpty {
                    markdownDocManager.createDoc(withTitle: viewModel.text)
                }
            }) {
                /// Create Button
                Image(systemName: "plus")
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.blue)
                    }
                    .foregroundStyle(.white)
            }
            .frame(maxHeight: .infinity)
            
        }
        .frame(height: 50)
    }
}

#Preview {
    Stored(MarkdownDocManager(), clickedDoc: { doc, content in
        
    })
}
