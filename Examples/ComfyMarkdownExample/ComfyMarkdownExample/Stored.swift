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
        ZStack {
            Color(NSColor.windowBackgroundColor).ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                if markdownDocManager.docs.isEmpty {
                    emptyState
                } else {
                    documentList
                }
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Documents")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .padding(.top, 24)
            
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                    TextField("New document title...", text: $viewModel.text)
                        .textFieldStyle(.plain)
                }
                .padding(12)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                
                Button(action: {
                    if !viewModel.text.isEmpty {
                        withAnimation(AppAnim.snap) {
                            markdownDocManager.createDoc(withTitle: viewModel.text)
                            viewModel.text = ""
                        }
                    }
                }) {
                    Text("Create")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(viewModel.text.isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.text.isEmpty)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private var documentList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(markdownDocManager.docs) { doc in
                    DocumentCard(doc: doc) {
                        let content = markdownDocManager.loadContent(for: doc)
                        clickedDoc(doc, content)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 64))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No documents yet")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Create your first markdown file above to get started.")
                .font(.subheadline)
                .foregroundColor(.secondary.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

struct DocumentCard: View {
    let doc: MarkdownDoc
    let action: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: "doc.text.fill")
                    .font(.title2)
                    .foregroundColor(.blue.opacity(0.8))
                    .frame(width: 44, height: 44)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(doc.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 12) {
                        Label(doc.updatedAt.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .padding(16)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isHovered ? Color.blue.opacity(0.3) : Color.gray.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(isHovered ? 0.08 : 0.03), radius: isHovered ? 8 : 4, y: isHovered ? 4 : 2)
            .scaleEffect(isHovered ? 1.01 : 1.0)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}


#Preview {
    Stored(MarkdownDocManager(), clickedDoc: { doc, content in
        
    })
}
