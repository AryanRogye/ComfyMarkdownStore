//
//  SidebarContainer.swift
//  CleanMarkdown
//
//  Created by Aryan Rogye on 8/12/25.
//

import SwiftUI

struct SidebarContainer<Content, Sidebar>: View where Content: View, Sidebar : View {
    
    private let content: () -> Content
    private let sidebar: () -> Sidebar
    
    @StateObject var viewModel = ViewModel()
    
    init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder sidebar: @escaping () -> Sidebar
    ) {
        self.content = content
        self.sidebar = sidebar
    }
    
    let sidebarWidth : CGFloat = 150
    
    var body: some View {
        ZStack {
            content()
            /// Disabled While Open
                .disabled(viewModel.showSidebar)
            /// Toolbar To Activate Sidebar
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        if !viewModel.showSidebar {
                            toolbar
                        }
                    }
                }
            
            if viewModel.showSidebar {
                sidebarOpacity
            }
            
            sidebar()
                .frame(maxWidth: sidebarWidth, maxHeight: .infinity)
                .background(.ultraThinMaterial)
                .shadow(radius: 12)
                .offset(x: viewModel.showSidebar
                        ? -sidebarWidth
                        : -sidebarWidth * 2
                )
                .animation(.easeOut(duration: 0.25), value: viewModel.showSidebar)
            
            if !viewModel.showSidebar {
                Color.clear
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
                    .highPriorityGesture(edgeDrag)
            }
        }
    }
    
    private var edgeDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onEnded { value in
                let startLocation = value.startLocation
                /// Make sure the place we start dragging for is in the sidebar width area
                guard !viewModel.showSidebar else { return }
                guard startLocation.x < sidebarWidth else {
                    print("Start location is outside sidebar width")
                    return
                }
                let dragX = value.translation.width
                
                if dragX > 50 {
                    viewModel.activateSidebar()
                }
            }
    }
    
    // MARK: - Toolbar
    private var toolbar: some View {
        Button(action: viewModel.activateSidebar) {
            Image(systemName: "list.bullet")
        }
    }
    
    // MARK: - Opacity
    private var sidebarOpacity: some View {
        Color.black.opacity(0.6)
            .ignoresSafeArea()
            .onTapGesture {
                viewModel.showSidebar = false
            }
    }
}

extension SidebarContainer {
    class ViewModel : ObservableObject {
        @Published var showSidebar: Bool = false
        
        public func activateSidebar() {
            withAnimation(AppAnim.snap) {
                showSidebar = true
            }
        }
    }
}
