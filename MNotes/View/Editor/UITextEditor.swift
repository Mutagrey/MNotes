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
    
    @Binding var note: Note
    
    private var currentAttributes: [NSAttributedString.Key : Any] {
        [
            .foregroundColor: UIColor(self.settings.fontSettings.textColor),
            .font: self.settings.getUIFont(),
            .strikethroughStyle: self.settings.fontSettings.isStrikethrough,
            .underlineStyle: self.settings.fontSettings.isUnderline,
            .shadow: self.settings.makeShadowFont()
        ]
    }
    
    func makeUIView(context: Context) -> UITextView {
        let uiView = UITextView()
        uiView.delegate = context.coordinator
        defaultStyle(for: uiView)
        return uiView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = note.attributedText
        updateSelectedText(for: uiView)
    }
    
    private func defaultStyle(for uiView: UITextView) {
        uiView.backgroundColor = .clear
        uiView.textContainerInset = .zero
        uiView.isEditable = true
        uiView.isScrollEnabled = true
        uiView.allowsEditingTextAttributes = true
//        uiView.adjustsFontForContentSizeCategory = true
    }

    func updateSelectedText(for uiView: UITextView) {
        if settings.applyCurrentAttributes {
            guard let text = uiView.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
            text.addAttributes(currentAttributes, range: uiView.selectedRange)
            uiView.attributedText = text.copy() as? NSMutableAttributedString
            settings.applyCurrentAttributes = false
        }
    }
}

struct UITextEditor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UITextEditor(note: .constant(.init()))
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
            self.parent.note.attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if self.parent.settings.showTextSettings { self.parent.settings.showTextSettings = false }
//            self.parent.note.attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            self.parent.note.attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
            self.parent.note.attributedData = textView.attributedText.rtfd
        }
        
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            textView.typingAttributes = self.parent.currentAttributes
            return true
        }
        
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            if let textRange = textView.selectedTextRange, let selectedText = textView.text(in: textRange) {
                self.parent.settings.selectedText = selectedText
            }
            
            if !(textView.selectedTextRange?.isEmpty ?? true) {
                self.parent.settings.showApplyCurrentAttributesButton = true
            } else {
                self.parent.settings.showApplyCurrentAttributesButton = false
            }
        }
        
    }
}
