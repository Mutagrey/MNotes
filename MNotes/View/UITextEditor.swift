//
//  UITextEditor.swift
//  MNotes
//
//  Created by Sergey Petrov on 23.03.2022.
//

import SwiftUI
import Combine

enum CustomAttributes {
    case menlo
    case times
    case important
    case `default`
    
    var attributeContainer: AttributeContainer {
        var container = AttributeContainer()
        switch self {
        case .menlo:
            container.font = .custom("Menlo", size: 30, relativeTo: .body)
            container.foregroundColor = .indigo
        case .times:
            container.font = .custom("Times New Roman", size: 17, relativeTo: .body)
            container.foregroundColor = UIColor.blue
        case .important:
            container.font = .custom("Courier New", size: 17, relativeTo: .body)
            container.backgroundColor = .yellow
        default:
            break
        }
        return container
    }
}

struct UITextEditor: UIViewRepresentable {
    @EnvironmentObject var settings: EditorSettingsViewModel
    
    @Binding var attributedString: AttributedString
    
    @AppStorage("fontSize") var fontSize: Double = 13
    
    var cancelables = Set<AnyCancellable>() // cancellables for notes
    
    func makeUIView(context: Context) -> UITextView {
        let uiView = UITextView()
        
        uiView.delegate = context.coordinator
        
        defaultStyle(for: uiView)
        
        return uiView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
//        uiView.textColor = UIColor(settings.fontSettings.textColor)
//        uiView.font = UIFont.systemFont(ofSize: CGFloat(settings.fontSettings.fontSize), weight: .regular)
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
            print("textViewDidChange: \(String(describing: textView.text!))")
            
            
            self.parent.attributedString = AttributedString(textView.attributedText)
//            self.parent.attributedString.mergeAttributes(self.parent.settings.currentAttributes)
        }
        
//        func textViewDidBeginEditing(_ textView: UITextView) {
//            print("textViewDidBeginEditing: \(String(describing: textView.text!))")
//            self.parent.attributedString.mergeAttributes(self.parent.settings.currentAttributes)
////            self.parent.attributedString = AttributedString(textView.attributedText)
//        }
        func textViewDidBeginEditing(_ textView: UITextView) {
            print("textViewDidBeginEditing:")
            self.parent.settings.showTextSettings = false
            textView.textColor = UIColor(self.parent.settings.fontSettings.textColor)
            textView.font = UIFont.systemFont(ofSize: CGFloat(self.parent.settings.fontSettings.fontSize), weight: .regular)
        }

        
        func textViewDidChangeSelection(_ textView: UITextView) {
//            if let textView.markedTextRange
//            if let textRange = textView.selectedTextRange {
//                guard
//                    let selectedText = textView.text(in: textRange),
//                    let range = self.parent.attributedString.range(of: selectedText)
//                else { return }
//                self.parent.attributedString[range].mergeAttributes(Note.getBaseAttributes())
//            }
        }

    }
}
