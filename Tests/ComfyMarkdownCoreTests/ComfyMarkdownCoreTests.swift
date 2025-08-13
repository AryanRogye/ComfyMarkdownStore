//
//  ComfyMarkdownCoreTests.swift
//  ComfyMarkdownCore
//
//  Created by Aryan Rogye on 8/13/25.
//

import XCTest
@testable import ComfyMarkdownCore

final class ComfyMarkdownCoreTests: XCTestCase {
    
    let comfyMarkdownCore = ComfyMarkdownCore()
    
    var baseMarkdown = """
        ## Hello World
        """
    
    func testSimpleAST() {
        do {
            let ast : MarkdownNode? = try comfyMarkdownCore.parse(markdown: baseMarkdown)
            guard let ast = ast else {
                XCTFail("AST should not be nil")
                return
            }
            
            print("BASE MARKDOWN: \(baseMarkdown)")
            ast.visualizeAST()
            
            XCTAssert(true, "AST parsed successfully")
            
        } catch let error as MarkdownASTError {
            switch error {
            case .invalidNode:
                XCTFail("Invalid node encountered in AST: \(error)")
            case .unsupportedNodeType:
                XCTFail("Unsupported node type in AST: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
