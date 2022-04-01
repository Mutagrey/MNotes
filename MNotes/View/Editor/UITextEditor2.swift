////
////  UITextEditor2.swift
////  MNotes
////
////  Created by Sergey Petrov on 28.03.2022.
////
//
//import Combine
//import SwiftUI
//import UIKit
//
//struct iOSEditorTextView: UIViewRepresentable {
//    //@Binding var text: String
//    @Binding var document: NSMutableAttributedString
//    var isEditable: Bool = true
//    var font: UIFont?    = .systemFont(ofSize: 14, weight: .regular)
//    
//    var onEditingChanged: () -> Void       = {}
//    var onCommit        : () -> Void       = {}
//    var onTextChange    : (String) -> Void = { _ in }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    func makeUIView(context: Context) -> CustomTextView {
//        let textView = CustomTextView(
//            text: document,
//            isEditable: isEditable,
//            font: font
//        )
//        textView.delegate = context.coordinator
//        
//        return textView
//    }
//    
//    func updateUIView(_ uiView: CustomTextView, context: Context) {
//        uiView.text = document
//        uiView.selectedRanges = context.coordinator.selectedRanges
//    }
//}
//
//// MARK: - Preview
//
//#if DEBUG
//
////iOSEditorTextView(
////    document: $document.text,
////    isEditable: true,
////    font: .systemFont(ofSize: 14, weight: .regular)
////)
//
//struct iOSEditorTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            iOSEditorTextView(
//                document: .constant(NSMutableAttributedString()),
//                isEditable: true,
//                font: .systemFont(ofSize: 14, weight: .regular)
//            )
//            .environment(\.colorScheme, .dark)
//            .previewDisplayName("Dark Mode")
//            
//            iOSEditorTextView(
//                document: .constant(NSMutableAttributedString()),
//                isEditable: false
//            )
//            .environment(\.colorScheme, .light)
//            .previewDisplayName("Light Mode")
//        }
//    }
//}
//
//#endif
//
//// MARK: - Coordinator
//
//extension iOSEditorTextView {
//    
//    class Coordinator: NSObject, UITextViewDelegate {
//        var parent: iOSEditorTextView
//        var selectedRanges: [NSValue] = []
//        
//        init(_ parent: iOSEditorTextView) {
//            self.parent = parent
//        }
//        
//        func textViewDidBeginEditing(_ textView: UITextView) {
//            self.parent.document = NSMutableAttributedString(attributedString: textView.attributedText)
//            self.parent.onEditingChanged()
//        }
//        
//        func textViewDidChange(_ textView: UITextView) {
//            self.parent.document = NSMutableAttributedString(attributedString: textView.attributedText)
//            //self.selectedRanges = textView.selectedRange
//        }
//
//        func textViewDidEndEditing(_ textView: UITextView) {
//            self.parent.document = NSMutableAttributedString(attributedString: textView.attributedText)
//            self.parent.onCommit()
//        }
//    }
//}
//
//// MARK: - CustomTextView
//
//final class CustomTextView: UIView, UIGestureRecognizerDelegate, UITextViewDelegate {
//    private var isEditable: Bool
//    private var font: UIFont?
//    
//    weak var delegate: UITextViewDelegate?
//    
//    var text: NSMutableAttributedString {
//        didSet {
//            textView.attributedText = text
//        }
//    }
//    
//    var selectedRanges: [NSValue] = [] {
//        didSet {
//            guard selectedRanges.count > 0 else {
//                return
//            }
//            
//            //textView.selectedRanges = selectedRanges
//        }
//    }
//        
//    private lazy var textView: UITextView = {
//        let textView                     = UITextView(frame: .zero)
//        textView.delegate                = self.delegate
//        textView.font                    = self.font
//        textView.isEditable              = self.isEditable
//        textView.textColor               = UIColor.label
//        textView.textContainerInset      = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        
//        return textView
//    }()
//
//    // Create paragraph styles
//    let paragraphStyle = NSMutableParagraphStyle() // create paragraph style
//
//    var attributes: [NSMutableAttributedString.Key: Any] = [
//        .foregroundColor: UIColor.red,
//        .font: UIFont(name: "Courier", size: 12)!
//    ]
//    
//    // MARK: - Init
//    init(text: NSMutableAttributedString, isEditable: Bool, font: UIFont?) {
//        self.font       = font
//        self.isEditable = isEditable
//        self.text       = text
//        
//        super.init(frame: .zero)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Life cycle
//    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        
//        setupTextView()
//        
//        // Set tap gesture
//        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:)))
//        tap.delegate = self
//        textView.addGestureRecognizer(tap)
//
//        // create paragraph style
//        self.paragraphStyle.headIndent = 108
//        
//        // create attributes
//        self.attributes = [
//            .foregroundColor: UIColor.red,
//            .font: UIFont(name: "Courier", size: 12)!,
//            .paragraphStyle: paragraphStyle,
//        ]
//    }
//    
//    // Show cursor and set it to position on tapping + Detect line
//    @objc func didTapTextView(_ recognizer: UITapGestureRecognizer) {
//        // Show cursor and set it to position on tapping
//        if recognizer.state == .ended {
//            textView.isEditable = true
//            textView.becomeFirstResponder()
//                        
//            let location = recognizer.location(in: textView)
//            if let position = textView.closestPosition(to: location) {
//                let uiTextRange = textView.textRange(from: position, to: position)
//                
//                if let start = uiTextRange?.start, let end = uiTextRange?.end {
//                    let loc = textView.offset(from: textView.beginningOfDocument, to: position)
//                    let length = textView.offset(from: start, to: end)
//                    
//                    textView.selectedRange = NSMakeRange(loc, length)
//                }
//            }
//            
//        }
//        
//    }
//        
//    func setupTextView() {
//        // Setup Text View delegate
//        textView.delegate = delegate
//        
//        // Place the Text View on the view
//        addSubview(textView)
//        
//        NSLayoutConstraint.activate([
//            textView.topAnchor.constraint(equalTo: topAnchor),
//            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//
//    }
//}
//
