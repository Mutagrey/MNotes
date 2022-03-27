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
        print("Updated")
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
            print("Changed")
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
                if self.parent.settings.showTextSettings { self.parent.settings.showTextSettings = false } 
            }
        }

        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            textView.typingAttributes = [
                .foregroundColor: UIColor(self.parent.settings.fontSettings.textColor),
                .font: self.parent.settings.getUIFont(),
                .strikethroughStyle: self.parent.settings.fontSettings.isStrikethrough,
                .underlineStyle: self.parent.settings.fontSettings.isUnderline,
                .shadow: self.parent.settings.makeShadowFont()
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

    }
}
