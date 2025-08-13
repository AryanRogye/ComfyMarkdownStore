# ComfyMarkdownStore

**ComfyMarkdownStore** is a Swift package that takes your Markdown — including GitHub Flavored Markdown (GFM) — and turns it into a clean, Swift-friendly Abstract Syntax Tree (AST).  

---

## Why?

Most Swift Markdown libraries either give you HTML or handle only a small subset of Markdown.  
**ComfyMarkdownStore** is built on top of [swift-cmark](https://github.com/swiftlang/swift-cmark) and supports **all GFM extensions** **at the parsing level**.  
That means tables, autolinks, strikethrough, task lists, footnotes, and more are recognized in the AST.  
**Rendering is up to you** — you can choose to draw only what you need for now, and expand later.
**ComfyMarkdownUI** is a WIP.

---

## Features

- **Full GFM parsing**  
  Tables, autolinks, strikethrough, task lists, footnotes, tag filtering — all recognized and available in the AST.
- **Swift-native AST**  
  Walk the tree, transform nodes, or build your own custom renderer.
- **UI agnostic**  
  Use it in SwiftUI, UIKit, AppKit — rendering is up to you.
- **Tested with XCTest**  
  Comes with basic tests.

---

## Installation

Add this package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/ComfyMarkdownStore.git", from: "0.1.0")
]
```

Then add it as a dependency for your target:

```swift
.target(
    name: "YourTarget",
    dependencies: ["ComfyMarkdownCore"]
)
```


## Usage

```swift
import ComfyMarkdownCore

let parser = ComfyMarkdownCore()
let markdown = """
## Hello World
This is **bold**, this is *italic*, and this is a [link](https://example.com).
"""

do {
    if let ast = try parser.parse(markdown: markdown) {
        ast.visualizeAST()
    }
} catch {
    print("Failed to parse markdown: \(error)")
}
```
