//
//  SettingsView.swift
//  ComfyMarkdownExample
//
//  Created by Aryan Rogye on 8/14/25.
//

import SwiftUI
import ComfyMarkdownUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: ContentView.ViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Comfy Markdown")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Text("A modern, modular markdown renderer for SwiftUI.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 12)
            }
            
            Section {
                ForEach(CurrentlySupported.allCases, id: \.self) { type in
                    NavigationLink(
                        destination: SettingsSupportedTypeExampleView(examples: type.examples)
                    ) {
                        Label {
                            Text(type.rawValue)
                                .font(.body)
                        } icon: {
                            Image(systemName: type.icon)
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                                .frame(width: 28, height: 28)
                                .background(Color.blue, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                    }
                }
            } header: {
                Text("Supported Syntax")
            } footer: {
                Text("More syntax support is being added in future updates.")
            }
            
            Section {
                Button(role: .destructive) {
                    // Placeholder for clearing cache or something
                } label: {
                    Label("Clear Local Cache", systemImage: "trash")
                }
            } header: {
                Text("Data Management")
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}



struct SettingsSupportedTypeExampleView: View {
    var examples: [String]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(examples, id: \.self) { example in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Example")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(example)
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.secondary.opacity(0.2))
                            )
                        
                        Text("Preview")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        ComfyMarkdown(text: example, maxFontSize: .constant(20))
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}
