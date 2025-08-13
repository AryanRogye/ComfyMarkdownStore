//
//  MarkdownNodeType.swift
//  ComfyMarkdownCore
//
//  Created by Aryan Rogye on 8/13/25.
//

enum MarkdownNodeType: Equatable {
    // ===== Block-level =====
    case document
    case blockQuote
    case list(ordered: Bool, start: Int, tight: Bool, delimiter: String?)
    case listItem
    case codeBlock(info: String?, literal: String)
    case htmlBlock(String)
    case customBlock(onEnter: String?, onExit: String?)
    case paragraph
    case heading(level: Int)
    case thematicBreak
    case footnoteDefinition
    
    case table_header
    case table
    case tableRow(header: Bool)
    case tableCell(align: Int?)
    
    // ===== Inline-level =====
    case text(String)
    case softBreak
    case lineBreak
    case code(String)
    case htmlInline(String)
    case customInline(onEnter: String?, onExit: String?)
    case emphasis
    case strong
    case link(url: String, title: String?)
    case image(url: String, title: String?)
    case footnoteReference
    case attribute // GFM-specific
    
    // ===== None / Unknown =====
    case none
}

extension MarkdownNodeType: CustomStringConvertible {
    var description: String {
        switch self {
        case .document:                                         return "(document)"
        case .heading(let level):                               return "(heading level=\(level))"
        case .paragraph:                                        return "(paragraph)"
        case .text(let text):                                   return "(text) \"\(text)\""
        case .emphasis:                                         return "(emphasis)"
        case .strong:                                           return "(strong)"
        case .list(let ordered, let start, _, let delimiter):   return "(list ordered=\(ordered) start=\(start) delimiter=\(delimiter ?? "nil"))"
        case .listItem:                                         return "(list_item)"
        case .codeBlock(let info, let literal):                 return "(code_block info=\(info ?? "nil") literal=\"\(literal)\")"
        case .link(let url, let title):                         return "(link url=\(url) title=\(title))"
        case .image(let url, let title):                        return "(image url=\(url) title=\(title))"
        case .htmlBlock(let html):                              return "(html_block) \"\(html)\""
        case .htmlInline(let html):                             return "(html_inline) \"\(html)\""
        case .blockQuote:                                       return "(block_quote)"
        case .customBlock(let onEnter, let onExit):             return "(custom_block onEnter=\(onEnter ?? "nil") onExit=\(onExit ?? "nil"))"
        case .customInline(let onEnter, let onExit):            return "(custom_inline onEnter=\(onEnter ?? "nil") onExit=\(onExit ?? "nil"))"
        case .thematicBreak:                                    return "(thematic_break)"
        case .softBreak:                                        return "(soft_break)"
        case .lineBreak:                                        return "(line_break)"
        case .code(let text):                                   return "(code) \"\(text)\""
        case .footnoteDefinition:                               return "(footnote_definition)"
        case .footnoteReference:                                return "(footnote_reference)"
        case .attribute:                                        return "(attribute)"
            /// Bit Ehh About
        case .table:                                            return "(table)"
        case .table_header:                                     return "(table_header)"
        case .tableRow(let header):                             return "(table_row header=\(header))"
        case .tableCell(let align):                             return "(table_cell align=\(align.map(String.init) ?? "nil"))"
        case .none:                                             return "(none)"
        }
    }
}
