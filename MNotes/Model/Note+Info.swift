//
//  Note+Info.swift
//  MNotes
//
//  Created by Sergey Petrov on 01.04.2022.
//

import SwiftUI

// MARK: - Info Note that describes features
extension Note {
    static var infoNote: Note {
        var infoNote = Note()
        infoNote.attributedText = NSMutableAttributedString(string: """
                This is the Note Info \r
                Tap to Edit this Note \r
                Features: \n
                - Edit note \r
                - Change font style \r
                - Change text color \r
                - Pin note \r
                - Choose color category for your Note
                """, attributes: Note.defaultNSAttributes)
        infoNote.isPinned = true
        
//        var textInfo = NSMutableAttributedString(string: "")
//        textInfo.su
        
//        infoNote.attributedText.addAttributes(range: infoNote.attributedText.string.range(of: "This is the Note Info "))
        return infoNote
    }
}
