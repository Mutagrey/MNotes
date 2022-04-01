//
//  Note+Codable.swift
//  MNotes
//
//  Created by Sergey Petrov on 01.04.2022.
//

import SwiftUI

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
        attributedData = try? container.decode(Data.self, forKey: .attributedData)
        // Checks if Data exist
        if let attributedData = attributedData {
            // get NSMutableAttributedString from Data
            attributedText = attributedData.rtfd ?? NSMutableAttributedString(string: "")
        }
    }
}
