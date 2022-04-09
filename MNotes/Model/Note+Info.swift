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
        infoNote.isPinned = true
        
        let textInfo = NSMutableAttributedString(string: "")
        var attributes: [NSAttributedString.Key : Any] = Note.defaultNSAttributes
        // Title1
        attributes = [
            .foregroundColor: UIColor.orange,
            .font: UIFont.systemFont(ofSize: 35, weight: .heavy).bold,
            .strikethroughStyle: false,
            .underlineStyle: false,
        ]
        textInfo.append(.init(attributedString: NSAttributedString(string: "📝MNotes \r", attributes: attributes)))

        
        // Title2
        attributes = [
            .foregroundColor: UIColor.systemIndigo,
            .font: UIFont.systemFont(ofSize: 35, weight: .heavy).bold,
            .strikethroughStyle: false,
            .underlineStyle: false,
        ]
        textInfo.append(.init(attributedString: NSAttributedString(string: "This is the Note Info \r", attributes: attributes)))

//        // Icon
//        let attachment = NSTextAttachment(image: UIImage(named: "notesIcon")!)
//        attachment.image = UIImage(named: "notesIcon")?.withRoundedCorners(toWidth: 50, radius: 5)
//        attachment.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
//        textInfo.append(.init(attachment: attachment))
        
        // Subtitle
        attributes = [
            .foregroundColor: UIColor.systemOrange,
            .font: UIFont.systemFont(ofSize: 22, weight: .medium),
            .strikethroughStyle: false,
            .underlineStyle: false,
        ]
        textInfo.append(.init(attributedString: NSAttributedString(string: "Tap to Edit this Note \r", attributes: attributes)))
        
        // Features
        attributes = [
            .foregroundColor: UIColor.systemYellow,
            .font: UIFont.systemFont(ofSize: 20, weight: .regular).bold,
            .strikethroughStyle: false,
            .underlineStyle: false,
        ]
        textInfo.append(.init(attributedString: NSAttributedString(string: "Features: \r", attributes: attributes)))
        
        // Change color
        attributes = [
            .foregroundColor: UIColor.systemGreen,
            .font: UIFont.systemFont(ofSize: 18, weight: .regular).italic,
            .strikethroughStyle: false,
            .underlineStyle: true,
        ]
        textInfo.append(.init(attributedString: NSAttributedString(string: """
                                                                   - Edit note \r
                                                                   - Change font style \r
                                                                   - Change text color \r
                                                                   - Pin note \r
                                                                   - Choose color category for your Note
                                                                   """, attributes: attributes)))
        infoNote.attributedText = textInfo
        infoNote.attributedData = textInfo.rtfd
        return infoNote
    }
}
