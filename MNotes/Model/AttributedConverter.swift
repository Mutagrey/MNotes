//
//  NSAttributedString.swift
//  MNotes
//
//  Created by Sergey Petrov on 28.03.2022.
//

import Foundation

/*
 .txt    // Plain Text Document Type (Simple Text)
 .html   // HTML  Text Document Type (Hypertext Markup Language)
 .rtf    // RTF   Text Document Type (Rich text format document)
 .rtfd   // RTFD  Text Document Type (Rich text format document with attachment)
 */

// MARK: - Convert from `NSAttributedString` to `Data`
extension NSAttributedString {

    var text: Data { toData(.plain) }
    var html: Data { toData(.html)  }
    var rtf:  Data { toData(.rtf)   }
    var rtfd: Data { toData(.rtfd)  }
    
    convenience init(data: Data, documentType: DocumentType, encoding: String.Encoding = .utf8) throws {
        try self.init(attributedString: .init(data: data, options: [.documentType: documentType, .characterEncoding: encoding.rawValue], documentAttributes: nil))
    }
    
    func toData(_ documentType: DocumentType) -> Data {
        // Discussion
        // Raises an rangeException if any part of range lies beyond the end of the receiver’s characters.
        // Therefore passing a valid range allow us to force unwrap the result
        try! data(from: .init(location: 0, length: length),
                  documentAttributes: [.documentType: documentType])
    }

}

// MARK: - Convert from `Data` to `NSAttributedString`
extension Data {
    
    var text: NSMutableAttributedString? { toAttributedString(.plain) }
    var html: NSMutableAttributedString? { toAttributedString(.html)  }
    var rtf:  NSMutableAttributedString? { toAttributedString(.rtf)   }
    var rtfd: NSMutableAttributedString? { toAttributedString(.rtfd)  }
    
    /// Convert from Data to NSMutableAttributedString
    ///
    /// ```
    /// documentType: .txt    // Plain Text Document Type (Simple Text)
    /// documentType: .html   // HTML  Text Document Type (Hypertext Markup Language)
    /// documentType: .rtf    // RTF   Text Document Type (Rich text format document)
    /// documentType: .rtfd   // RTFD  Text Document Type (Rich text format document with attachment)
    ///```
    func toAttributedString(_ documentType: NSMutableAttributedString.DocumentType) -> NSMutableAttributedString? {
        let options : [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: documentType,
            .characterEncoding: String.Encoding.utf8
        ]
        return try? NSMutableAttributedString(data: self, options: options, documentAttributes: nil)
    }
}
