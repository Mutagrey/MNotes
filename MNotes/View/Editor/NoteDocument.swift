//
//  NoteDocument.swift
//  MNotes
//
//  Created by Sergey Petrov on 29.03.2022.
//

//import SwiftUI
//import UniformTypeIdentifiers
//
//extension UTType {
//    static var MyextDocument = UTType(exportedAs: "com.example.Myext.mxt")
//}
//
//struct MyextDocument: FileDocument {
//    var text: NSMutableAttributedString
//
//    init(text: NSMutableAttributedString = NSMutableAttributedString()) {
//        self.text = text
//    }
//
//    static var readableContentTypes: [UTType] { [.MyextDocument] }
//
//    init(configuration: ReadConfiguration) throws {
//        guard let data = configuration.file.regularFileContents,
//              let string = try? NSMutableAttributedString(data: data, options: [NSMutableAttributedString.DocumentReadingOptionKey.documentType : NSMutableAttributedString.DocumentType.rtf], documentAttributes: nil)
//        else {
//            throw CocoaError(.fileReadCorruptFile)
//        }
//        text = string
//    }
//
//    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
//        let data = (try? text.data(from: NSMakeRange(0, text.length), documentAttributes: [.documentType: NSMutableAttributedString.DocumentType.rtf]))!
//        return .init(regularFileWithContents: data)
//    }
//}
