//
//  EditorSettingsViewModel.swift
//  MNotes
//
//  Created by Sergey Petrov on 19.03.2022.
//

import SwiftUI


enum FontFormatSetting: String {
    case bold
    case italic
    case underline
    case strikethrough
    case shadow

    var systemIconName: String {
        get {
            switch self {
            case .bold:
                return "bold"
            case .italic:
                return "italic"
            case .underline:
                return "underline"
            case .strikethrough:
                return "strikethrough"
            case .shadow:
                return "shadow"
            }
        }
    }
}

class EditorSettingsViewModel: ObservableObject {
    
    @Published var showEditorSettings: Bool = false
    
//    @Published var selectedSetting: EditorSettings = .text

    @Published var isBold: Bool = false
    @Published var isItalic: Bool = false
    @Published var isUnderline: Bool = false
    @Published var isStrikethrough: Bool = false
    @Published var isShadow: Bool = false
    
    @Published var textColor: Color = Color.white
//    @Published var font: UIFont = UIFont.systemFont(ofSize: 35, weight: .regular)
    @Published var fontSize: Double = 14
    
    
    @Published var attrString: AttributedString = AttributedString("asdasdasd")//, attributes: currentAttributes)
    
    var currentAttributes: AttributeContainer {
        var attr = AttributeContainer()
        
//        var attributedString = AttributedString("The first month of your subscription is free.")
//        let range = attributedString.range(of: "free")!
//        attributedString[range].mergeAttributes(<#T##attributes: AttributeContainer##AttributeContainer#>)
//        attributedString[range].foregroundColor = .green
        
        attr.foregroundColor = UIColor(textColor)
        attr.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        
        return attr
    }
    
    func addCurrentAttributesToString(for range: Range<AttributedString.Index>?) {
        if let range = range {
            
        }
    }
}
