//
//  AttributedStringExample.swift
//  MNotes
//
//  Created by Sergey Petrov on 21.03.2022.
//

import SwiftUI

/* IVO pattern:
 I - Identifiable
 V - View
 O - Observed
 */

// MARK: - View
struct AttributedStringExample: View {
//    @EnvironmentObject var settings: EditorSettingsViewModel
//    @EnvironmentObject var vm: NotesViewModel
    @StateObject var observed = Observed()
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var dismiss: Bool
    
    @State private var noteID = 0
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                UIKTextEditor(text: $observed.text, textStyle: $observed.textStyle)
                    .padding(.horizontal)
                    .focused($dismiss)
                    .padding(.top)
            }
            .navigationTitle("Text Editor")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
//        .searchable(text: $observed.searchText, placement: .automatic, prompt: "Search text")
    }
}

struct AttributedStringExample_Previews: PreviewProvider {
    static var previews: some View {
        AttributedStringExample()
            .preferredColorScheme(.dark)
//            .environmentObject(EditorSettingsViewModel())
//            .environmentObject(NotesViewModel())
//            .environmentObject(Observer())
    }
}
// MARK: - Identifiable
struct AttributedStringModel: Identifiable {
    var id = UUID().uuidString
    var text: String = ""
    var attributedString: NSMutableAttributedString?
}

// MARK: - Observed
extension AttributedStringExample {
    class Observed: ObservableObject {
        @Published var attributedString: NSMutableAttributedString? // = NSMutableAttributedString("")
        @Published var searchText: String = ""
        @Published var text: String = "Hello world"
        @Published var aStrings: [AttributedStringModel] = []
        @Published var textStyle: UIFont.TextStyle = UIFont.TextStyle.body //= "Hello world"
        
        init() {
            getAStrings()
        }
        
        func getAStrings() {
            let quote = "Haters gonna hate"
            let font = UIFont.systemFont(ofSize: 72)
            let attributes = [NSAttributedString.Key.font: font]
            let attributedQuote = NSMutableAttributedString(string: quote, attributes: attributes)
            
//
//            var attributedString = AttributedString("This is a basic string that contains a link.")
//            let range = attributedString.range(of: "link")!
//            attributedString[range].link = URL(string: "https://www.example.com")
            
            self.attributedString = attributedQuote
        }
    }
}


struct UIKTextEditor: UIViewRepresentable {

    @Binding var text: String
    @Binding var textStyle: UIFont.TextStyle
 
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        
//        textView.font = UIFont(name: "HelveticaNeue", size: 45)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
//        textView.backgroundColor = UIColor(white: 0.4, alpha: 0.05)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        
        
        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.allowsEditingTextAttributes = true
        
        
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
     
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: UIKTextEditor
        
        init(_ textView: UIKTextEditor) {
            self.parent = textView
        }
     
        func textViewDidChange(_ textView: UITextView) {
            print("text now: \(String(describing: textView.text!))")
//            self.parent.$text.wrappedValue = textView.text
            self.parent.text = textView.text
        }
    }
}




// MARK: - Top Toolbar
extension AttributedStringExample {
//    private func topToolBar(noteID: Int) -> some View {
//        HStack {
//            VStack(alignment: .trailing, spacing: 6){
//                Text("\(vm.notes[noteID].wordsCount) words")
//                    .font(.subheadline)
//                Text("\(vm.notes[noteID].date.dateToString(formatString: "d.MM.YY, E HH:mm "))")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//            PinnedButtonView(note: $vm.notes[noteID])
//        }
//    }
    
    
    private var styleButton: some View {
        Button(action: {
            observed.textStyle = (observed.textStyle == .body) ? .title1 : .body
         }) {
             Image(systemName: "textformat")
                 .imageScale(.large)
                 .frame(width: 40, height: 40)
                 .foregroundColor(.white)
                 .background(Color.purple)
                 .clipShape(Circle())
  
         }
         .padding()
    }
    
    private var actionButton: some View {
        Button(action: {
            observed.attributedString = NSMutableAttributedString("sadasdasd")
         }) {
             Image(systemName: "textformat")
                 .imageScale(.large)
                 .frame(width: 40, height: 40)
                 .foregroundColor(.white)
                 .background(Color.green)
                 .clipShape(Circle())
  
         }
         .padding()
    }
}

struct UIKTextView: UIViewRepresentable {
    
    typealias UIViewType = UITextView
    var configuration = { (view: UIViewType) in }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIViewType {
        UIViewType()
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<Self>) {
        configuration(uiView)
    }
}
