//
//  UITextEditor.swift
//  MNotes
//
//  Created by Sergey Petrov on 23.03.2022.
//

import SwiftUI
import Combine

struct UITextEditor: UIViewRepresentable {
    @EnvironmentObject var settings: EditorSettingsViewModel
    
    @Binding var attributedString: AttributedString
            
    func makeUIView(context: Context) -> UITextView {
        let uiView = UITextView()
        
        uiView.delegate = context.coordinator
        
        defaultStyle(for: uiView)
        
        return uiView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        
        
        uiView.attributedText = NSAttributedString(attributedString)
    }
    
    private func defaultStyle(for uiView: UITextView) {
        uiView.backgroundColor = .clear
        uiView.textContainerInset = .zero
        uiView.isEditable = true
        uiView.isScrollEnabled = true
//        uiView.textContainer.lineFragmentPadding = 0
        uiView.allowsEditingTextAttributes = true
        
        uiView.isUserInteractionEnabled = true
        uiView.autocapitalizationType = .sentences
        uiView.isSelectable = true
    }

}

struct UITextEditor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UITextEditor(attributedString: .constant(.init("***BBSdSD ***")))
        }
        
    }
}

// MARK: - Coordinator
extension UITextEditor {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
     
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: UITextEditor
        
        init(_ textView: UITextEditor) {
            self.parent = textView
        }
     
        func textViewDidChange(_ textView: UITextView) {
            self.parent.attributedString = AttributedString(textView.attributedText)
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            self.parent.settings.showTextSettings = false
        }

        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            textView.typingAttributes = [
                .foregroundColor: UIColor(self.parent.settings.fontSettings.textColor),
                .font: getUIFont(),
                .strikethroughStyle: self.parent.settings.fontSettings.isStrikethrough,
                .underlineStyle: self.parent.settings.fontSettings.isUnderline,
                .shadow: makeShadowFont()
            ]
            return true
        }
        
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            if !(textView.selectedTextRange?.isEmpty ?? true) {
                self.parent.settings.showApplyCurrentAttributesButton = true
            } else {
                self.parent.settings.showApplyCurrentAttributesButton = false
            }
            
//            if  self.parent.settings.applyCurrentAttributes {
//                if let textRange = textView.selectedTextRange {
//                    guard
//                        let selectedText = textView.text(in: textRange),
//                        let range = self.parent.attributedString.range(of: selectedText)
//                    else { return }
//                    self.parent.attributedString[range].mergeAttributes(self.parent.settings.currentAttributes)
//                    self.parent.settings.applyCurrentAttributes = false
//                }
//            }
        }
        
        func getUIFont() -> UIFont {
            
            if self.parent.settings.fontSettings.isBold && !self.parent.settings.fontSettings.isItalic {
                return UIFont.systemFont(ofSize: CGFloat(self.parent.settings.fontSettings.fontSize), weight: .regular).bold
            }
            
            if !self.parent.settings.fontSettings.isBold && self.parent.settings.fontSettings.isItalic {
                return UIFont.systemFont(ofSize: CGFloat(self.parent.settings.fontSettings.fontSize), weight: .regular).italic
            }
            
            if self.parent.settings.fontSettings.isBold && self.parent.settings.fontSettings.isItalic {
                return UIFont.systemFont(ofSize: CGFloat(self.parent.settings.fontSettings.fontSize), weight: .regular).boldItalic
            }
            
            return UIFont.systemFont(ofSize: CGFloat(self.parent.settings.fontSettings.fontSize), weight: .regular)

        }
        
        func makeShadowFont() -> NSShadow {
            let attributedStringShadow = NSShadow()
            if self.parent.settings.fontSettings.isShadow {
                attributedStringShadow.shadowOffset = CGSize(width: 5, height: 5)
                attributedStringShadow.shadowBlurRadius = 5.0
                attributedStringShadow.shadowColor = UIColor(self.parent.settings.fontSettings.textColor.opacity(0.5))
            }
            return attributedStringShadow
        }

    }
}
