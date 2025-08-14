# ComfyMarkdownStore

**ComfyMarkdownStore** is a Swift package that takes your Markdown — including GitHub Flavored Markdown (GFM) — and turns it into a clean, Swift-friendly Abstract Syntax Tree (AST).

---

## Example Screenshots

<img src="https://github.com/user-attachments/assets/25440245-729b-4f14-aecb-24636284e4ce" height="300"/>
<img src="https://github.com/user-attachments/assets/e7d17fd5-334b-43e4-915e-74bbc39a8700" height="300"/>
<img src="https://github.com/user-attachments/assets/958d5827-1701-408b-b967-696bfaf6f4f1" height="300"/>
<img src="https://github.com/user-attachments/assets/dc421166-ec77-46c5-908a-b143d81aa470" height="300"/>
<img src="https://github.com/user-attachments/assets/4d2936f0-2b2f-4145-a2ef-1ae8191c2790" height="300"/>
<img src="https://github.com/user-attachments/assets/67a0c85a-b210-453e-8f10-7c877f97d2dc" height="300"/>

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
