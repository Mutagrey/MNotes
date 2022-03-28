//
//  EditorSettingsViewModel.swift
//  MNotes
//
//  Created by Sergey Petrov on 19.03.2022.
//

import SwiftUI
import Combine

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

struct FontSettings {
    var isBold: Bool = false
    var isItalic: Bool = false
    var isUnderline: Bool = false
    var isStrikethrough: Bool = false
    var isShadow: Bool = false
    var textColor: Color = Color.white
    var fontSize: Double = 20
}

class EditorSettingsViewModel: ObservableObject {
    
    @Published var showTextSettings: Bool = false
    @Published var showApplyCurrentAttributesButton: Bool = false
    @Published var applyCurrentAttributes: Bool = false
    
    @Published var selectedText: String = ""

    @Published var fontSettings: FontSettings = .init()
    @Published var currentAttributes: AttributeContainer = AttributeContainer()
    
    private var cancelables = Set<AnyCancellable>() // cancellables
    
    init() {
        onChangeAttributes()
    }
    
    func onChangeAttributes() {
        $fontSettings
            .sink { [weak self] (settings) in
                guard let self = self else { return }
                self.currentAttributes.foregroundColor = UIColor(settings.textColor)
                self.currentAttributes.font = self.getUIFont()
                if settings.isUnderline {
                    self.currentAttributes.underlineStyle = .byWord
                    self.currentAttributes.underlineColor = UIColor(settings.textColor)
                }
                if settings.isStrikethrough {
                    self.currentAttributes.strikethroughStyle = .byWord
                    self.currentAttributes.strikethroughColor = UIColor(settings.textColor)
                }
                if settings.isShadow {
                    self.currentAttributes.shadow = self.makeShadowFont()
                }
            }
            .store(in: &cancelables)
    }
    
    func getUIFont() -> UIFont {
        if fontSettings.isBold && !fontSettings.isItalic {
            return UIFont.systemFont(ofSize: CGFloat(fontSettings.fontSize), weight: .regular).bold
        }
        if !fontSettings.isBold && fontSettings.isItalic {
            return UIFont.systemFont(ofSize: CGFloat(fontSettings.fontSize), weight: .regular).italic
        }
        if fontSettings.isBold && fontSettings.isItalic {
            return UIFont.systemFont(ofSize: CGFloat(fontSettings.fontSize), weight: .regular).boldItalic
        }
        return UIFont.systemFont(ofSize: CGFloat(fontSettings.fontSize), weight: .regular)
    }
    
    func makeShadowFont() -> NSShadow {
        let attributedStringShadow = NSShadow()
        if fontSettings.isShadow {
            attributedStringShadow.shadowOffset = CGSize(width: 5, height: 5)
            attributedStringShadow.shadowBlurRadius = 5.0
            attributedStringShadow.shadowColor = UIColor(fontSettings.textColor.opacity(0.5))
        }
        return attributedStringShadow
    }
    
}
