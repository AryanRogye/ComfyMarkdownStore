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
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                close
            }
            .padding([.horizontal, .top])
            
            HStack {
                Text("Supported Types:")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal)
            
            supportedTypes
            
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .leading
        )
    }
    
    private var supportedTypes: some View {
        ScrollView {
            ForEach(CurrentlySupported.allCases, id: \.self) { type in
                NavigationLink(
                    destination: SettingsSupportedTypeExampleView(examples: type.examples)
                ) {
                    item(for: type)
                        .padding(.horizontal)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func item(for type: CurrentlySupported) -> some View {
        HStack(spacing: 16) {
            Image(systemName: type.icon)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 32, height: 32)
                .background(Color.accentColor, in: Circle())
            
            Text(type.rawValue)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 10)
        .contentShape(Rectangle()) // full row tap target
    }
    
    private var close: some View {
        Button(action: viewModel.toggleSettings) {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .padding(8)
                .background(.thinMaterial, in: Circle())
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .topTrailing)
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
