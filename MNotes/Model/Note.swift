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
            return Color(UIColor.secondarySystemFill)
        }
    }
}

// Note Model
struct Note: Identifiable, Hashable {
    
    var id = UUID().uuidString

    var attributedData: Data? // RTFD  Text Document Type (Rich text format document with attachment)
    
    var attributedText: NSMutableAttributedString = NSMutableAttributedString(string: "")
    
    var date: Date = Date()

    var isPinned: Bool = false
    var category: NoteCategory? = .default
    
    var folderURL: URL { LocalFileManager.rootURL.appendingPathComponent(id) } // Gets folder rootURL/<ID>/
    var title: String { getTitle() }
    var subtitle: NSAttributedString { getSubtitle() }
    var wordsCount: Int { attributedText.string.split { $0 == " " || $0.isNewline }.count }
    var images: [UIImage] {
        return []
    }

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
        let lastIndex = attributedText.string.count - startIndex - 1
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
}

// Codable Note
extension Note: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case isPinned
        case category
        case attributedData
        case attributedText
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(isPinned, forKey: .isPinned)
        try container.encode(category, forKey: .category)
        try container.encode(attributedData, forKey: .attributedData)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        isPinned = try container.decode(Bool.self, forKey: .isPinned)
        category = try? container.decode(NoteCategory.self, forKey: .category)
        attributedData = try container.decode(Data.self, forKey: .attributedData)
        // get NSMutableAttributedString from Data as
        if let attributedData = attributedData {
            attributedText = attributedData.rtfd ?? NSMutableAttributedString(string: "")// toAttributedString(from: attributedData, documentType: .rtfd) ?? NSMutableAttributedString(string: "")
        }
    }
}

