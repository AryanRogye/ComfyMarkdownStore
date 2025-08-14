// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ComfyMarkdownStore",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    /// Products
    products: [
        .library(
            name: "ComfyMarkdownCore",
            targets: ["ComfyMarkdownCore"]
        ),
        /// More Products go here
        .library(
            name: "ComfyMarkdownUI",
            targets: ["ComfyMarkdownUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-cmark", branch: "gfm")
    ],
    // MARK: - Targets
    targets: [
        // MARK: - Core
        .target(
            name: "ComfyMarkdownCore",
            dependencies: [
                .product(name: "cmark-gfm", package: "swift-cmark"),
                .product(name: "cmark-gfm-extensions", package: "swift-cmark"),
            ]
        ),
        .testTarget(
            name: "ComfyMarkdownCoreTests",
            dependencies: ["ComfyMarkdownCore"]
        ),
        /// MARK: - UI
        .target(
            name: "ComfyMarkdownUI",
            dependencies: ["ComfyMarkdownCore"],
            resources: [
                // if I have resources, I can add them here
                // .process("Resources")
            ]
        ),
        /// No Tests for ComfyMarkdownUI yet
        
        /// Executable
            .executableTarget(
                name: "ComfyMarkdownExample",
                dependencies: ["ComfyMarkdownUI"],
                path: "Examples/ComfyMarkdownExample/ComfyMarkdownExample"
            )
    ]
)
