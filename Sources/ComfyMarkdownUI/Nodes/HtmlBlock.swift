//
//  HtmlBlock.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/24/25.
//

import SwiftUI

struct HTMLBlockView: View {
    let literal: String
    
    var body: some View {
        if let summary = SummaryRow.parse(from: literal) {
            SummaryRowView(summary: summary)
        } else {
            // ignore other html (like <details> and </details>)
            EmptyView()
        }
    }
}

struct SummaryRow {
    let prefix: String       // e.g. "View Changes |"
    let linkLabel: String?   // e.g. "f674691"
    let url: URL?            // href from <a>
    
    static func parse(from html: String) -> SummaryRow? {
        // only handle <summary>…</summary>
        guard let inner = html.firstMatch(capturing: #"(?is)<summary(?:\s[^>]*)?>(.*?)</summary>"#)
        else { return nil }
        
        // grab first link href + label (prefer <code>...</code> as label)
        let href = inner.firstMatch(capturing: #"(?is)href="([^"]+)""#)
        let codeLabel = inner.firstMatch(capturing: #"(?is)<code>(.*?)</code>"#)
        let anchorLabel = codeLabel ?? inner.firstMatch(capturing: #"(?is)<a[^>]*>(.*?)</a>"#)?.stripTags()
        
        // remove the entire <a>…</a> from the text to get the prefix
        let prefixRaw = inner.replacingOccurrences(
            of: #"(?is)<a[^>]*>.*?</a>"#,
            with: "",
            options: .regularExpression
        ).stripTags().trimmedHTML()
        
        return SummaryRow(
            prefix: prefixRaw.isEmpty ? "Details" : prefixRaw,
            linkLabel: anchorLabel?.trimmedHTML(),
            url: href.flatMap(URL.init(string:))
        )
    }
}

struct SummaryRowView: View {
    let summary: SummaryRow
    
    @Environment(\.markdownTheme) private var theme
    @Environment(\.maxFontSize) private var maxHeadingSize
    
    var body: some View {
        HStack(spacing: 6) {
            Text(summary.prefix)
                .font(
                    theme.bodyFont(
                        maxHeadingSize: maxHeadingSize
                    )
                )
            if let label = summary.linkLabel,
               let url = summary.url {
                if #available(iOS 16.0, *) {
                    Link(label, destination: url)
                        .font(.system(.body, design: .monospaced)) // matches <code> vibe
                        .underline()
                } else {
                    Link(label, destination: url)
                        .font(.system(.body, design: .monospaced)) // matches <code> vibe
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 6)
    }
}

private extension String {
    func firstMatch(capturing pattern: String) -> String? {
        guard let re = try? NSRegularExpression(pattern: pattern, options: [] ) else { return nil }
        let range = NSRange(startIndex..., in: self)
        guard let m = re.firstMatch(in: self, options: [], range: range),
              m.numberOfRanges >= 2,
              let r = Range(m.range(at: 1), in: self) else { return nil }
        return String(self[r])
    }
    func stripTags() -> String {
        replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
    func trimmedHTML() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: #"\s+\n"#, with: "\n", options: .regularExpression)
            .replacingOccurrences(of: #"\n\s+"#, with: "\n", options: .regularExpression)
    }
}
