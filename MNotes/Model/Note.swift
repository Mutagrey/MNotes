//
//  Note.swift
//  MNotes
//
//  Created by Sergey Petrov on 15.03.2022.
//

import SwiftUI

// Note Category by colors
enum NoteCategory: String, CaseIterable, Codable {
    
    case `default`
    case orange
    case blue
    case red
    case green

    var color: Color {
        switch self {
        case .orange:
            return Color(UIColor.orange)
        case .blue:
            return Color(UIColor.systemBlue)
        case .red:
            return Color(UIColor.systemRed)
        case .green:
            return Color(UIColor.systemGreen)
        case .default:
            return Color(UIColor.systemGray)
        }
    }
}

// Note Model
struct Note: Identifiable, Hashable {
    
    var id = UUID().uuidString
    var date: Date = Date()
    // Attributed Data
    var attributedData: Data? // RTFD  Text Document Type (Rich text format document with attachment)
    var attributedText: NSMutableAttributedString = NSMutableAttributedString(string: "")
    
    var isPinned: Bool = false
    var category: NoteCategory? = .default
    
    var folderURL: URL { LocalFileManager.rootURL.appendingPathComponent(id) } // Gets folder rootURL/<ID>/
    var title: String { getTitle() }
    var subtitle: NSAttributedString { getSubtitle() }
    var wordsCount: Int { attributedText.string.split { $0 == " " || $0.isNewline }.count }
    var images: [UIImage] { getImages() }
    
    // MARK: - Methods
    // Gets title of NSMutableAttributedString as String
    private func getTitle() -> String {
        let strMass = attributedText.string.split(separator: "\n")
        if strMass.count > 0 {
            return (String(strMass[0]))
        }
        return ""
    }
    
    // Gets subtitle of NSMutableAttributedString with default font size
    private func getSubtitle() -> NSAttributedString {
        let startIndex = title.count + 1
        let lastIndex = attributedText.string.count - startIndex //- 1
        let range = NSMakeRange(startIndex, lastIndex)
        let attributes: [NSAttributedString.Key : Any] = Note.defaultNSAttributes.filter({$0.key == .font})
        
        var text: NSMutableAttributedString? = nil
        if startIndex < lastIndex {
            text = attributedText.attributedSubstring(from: range).mutableCopy() as? NSMutableAttributedString
        } else {
            text = attributedText.mutableCopy() as? NSMutableAttributedString
        }
        
        if let text = text {
            text.addAttributes(attributes, range: NSMakeRange(0, text.string.count))
            return text.copy() as? NSAttributedString ?? attributedText
        }
        
        return attributedText
    }

    /// Default Attributes for NSAttributedString
    /// ```
    ///     .foregroundColor: UIColor.white
    ///     .font: UIFont.systemFont(ofSize: 18, weight: .regular)
    /// ```
    static var defaultNSAttributes: [NSAttributedString.Key : Any] {
        [.foregroundColor: UIColor.white,
         .font: UIFont.systemFont(ofSize: 18, weight: .regular)]
    }
    
    /// Get Images from AttributedString
    private func getImages() -> [UIImage] {
        var images: [UIImage] = []
        attributedText.enumerateAttribute(.attachment, in: NSRange(0..<attributedText.length)) { value, range, stop in
            if let attachment = value as? NSTextAttachment,
               let data = attachment.fileWrapper?.regularFileContents,
               let img = UIImage(data: data) {
                images.append(img)
            }
        }
        return images
    }
}


