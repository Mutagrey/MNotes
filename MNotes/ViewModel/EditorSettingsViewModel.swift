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
    var fontSize: Double = 14
}

class EditorSettingsViewModel: ObservableObject {
    
    @Published var showTextSettings: Bool = false
    
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
                self.currentAttributes.font = UIFont.systemFont(ofSize: settings.fontSize, weight: .regular)
//                self.attrString.mergeAttributes(self.currentAttributes)
            }
            .store(in: &cancelables)
    }
}
