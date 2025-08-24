//
//  MarkdownDocManager.swift
//  ComfyMarkdownExample
//
//  Created by Aryan Rogye on 8/24/25.
//

import Combine
import Foundation

struct MarkdownDoc: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var filename: String
    var createdAt: Date
    var updatedAt: Date
}

@MainActor
class MarkdownDocManager: ObservableObject {
    @Published private(set) var docs: [MarkdownDoc] = []
    
    private let fm = FileManager.default
    private let folderURL: URL
    
    init() {
        let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appFolder = base.appendingPathComponent("ComfyMarkdown", isDirectory: true)
        
        if !fm.fileExists(atPath: appFolder.path) {
            try? fm.createDirectory(at: appFolder, withIntermediateDirectories: true)
        }
        self.folderURL = appFolder
        getDocs()
    }
    
    func loadContent(for doc: MarkdownDoc) -> String {
        let url = folderURL.appendingPathComponent(doc.filename)
        if let data = try? Data(contentsOf: url),
           let text = String(data: data, encoding: .utf8) {
            return text
        }
        return ""
    }
    
    func saveContent(for doc: MarkdownDoc, with content: String) {
        let url = folderURL.appendingPathComponent(doc.filename)
        
        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
            
            // Update modified date in our docs array
            if let idx = docs.firstIndex(where: { $0.filename == doc.filename }) {
                docs[idx].updatedAt = Date()
            }
        } catch {
            print("Save error:", error)
        }
    }
    
    func createDoc(withTitle title: String) {
        let safeTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !safeTitle.isEmpty else { return }
        
        // Build filename
        let filename = safeTitle.replacingOccurrences(of: " ", with: "_") + ".md"
        let fileURL = folderURL.appendingPathComponent(filename)
        
        // If already exists, bail (or you could append a number)
        guard !fm.fileExists(atPath: fileURL.path) else { return }
        
        // Write empty file
        let body = "# \(safeTitle)\n\n"
        try? body.write(to: fileURL, atomically: true, encoding: .utf8)
        
        // Get file attributes
        let attrs = (try? fm.attributesOfItem(atPath: fileURL.path)) ?? [:]
        let createdAt = attrs[.creationDate] as? Date ?? Date()
        let updatedAt = attrs[.modificationDate] as? Date ?? Date()
        
        // Add to docs
        let newDoc = MarkdownDoc(
            id: UUID(),
            title: safeTitle,
            filename: filename,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
        
        docs.insert(newDoc, at: 0) // newest first
    }
    
    func getDocs() {
        guard let items = try? fm.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil) else {
            docs = []
            return
        }
        
        let markdownFiles = items.filter { $0.pathExtension == "md" }
        
        docs = markdownFiles.map { url in
            let attrs = (try? fm.attributesOfItem(atPath: url.path)) ?? [:]
            let createdAt = attrs[.creationDate] as? Date ?? .distantPast
            let updatedAt = attrs[.modificationDate] as? Date ?? .distantPast
            
            return MarkdownDoc(
                id: UUID(),
                title: url.deletingPathExtension().lastPathComponent,
                filename: url.lastPathComponent,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
        .sorted(by: { $0.updatedAt > $1.updatedAt })
    }
}
