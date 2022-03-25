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
struct Note: Identifiable, Codable, Hashable {
    
    var id = UUID().uuidString

    var attributedText: AttributedString = AttributedString("", attributes: Note.defaultAttributes())
    var date: Date = Date()

    var isPinned: Bool = false
    var category: NoteCategory? = .default
            
    var folderURL: URL { LocalFileManager.rootURL.appendingPathComponent(id) } // Gets folder rootURL/<ID>/
    var title: String { getTitle(attributedText) }
    var subtitle: AttributedString { getSubtitle(attributedText) }
    var wordsCount: Int { attributedText.characters.split { $0 == " " || $0.isNewline }.count }
    var baseTextAttributes: AttributeContainer { Note.defaultAttributes() }

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case isPinned
        case category
        case attributedText
    }
    
    // MARK: - Methods
    private func getTitle(_ aText: AttributedString) -> String {
        
        let strMass = aText.characters.split(separator: "\n")
        if strMass.count > 0 {
            return (String(strMass[0]))
        }
        return ""
    }
    
    private func getSubtitle(_ aText: AttributedString) -> AttributedString {
        let strMass = aText.characters.split(separator: "\n")
        if strMass.count > 1 {
            return AttributedString(strMass[1], attributes: Note.defaultAttributes())
        }
        return ""
    }

    static func defaultAttributes() -> AttributeContainer {
        var attr = AttributeContainer()
        attr.foregroundColor = UIColor.white
        attr.font = UIFont.systemFont(ofSize: 20, weight: .regular) //.system(size: 20, weight: .regular, design: .rounded)
        return attr
    }
    
}


