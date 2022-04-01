//
//  NoteEditor2.swift
//  MNotes
//
//  Created by Sergey Petrov on 20.03.2022.
//

import SwiftUI

struct NoteEditor: View {
    @EnvironmentObject var vm: NotesViewModel
    @EnvironmentObject var settings: EditorSettingsViewModel
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedNoteID: String?
    @FocusState var dismiss: Bool
    
    @State private var showCategoryPicker: Bool = false
    @State private var category: NoteCategory?
    
    @State var note: Note = .init()
    @State var deletionAlert: Bool = false
        
    var body: some View {
        VStack(spacing: 0){
            UITextEditor(note: $note)
                .focused($dismiss)
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
            Spacer(minLength: 0)
            imageViwer
                .padding(.horizontal)
                .padding(.bottom, 8)
            editBar
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                topToolBar(note: note)
            }
            ToolbarItemGroup(placement: .bottomBar) {
                if !dismiss { editMenuBar }
            }
        }
        .overlay(CategoryPickerSelector(show: $showCategoryPicker, category: $note.category, size: 20, categoryPosition: .vertical), alignment: .topTrailing)
        .sheet(isPresented: $settings.showImagePicker) {
            ImagePicker(results: $settings.images, attributedString: $note.attributedText)
        }
        // Update and save changes
        .onDisappear {
            if note.wordsCount == 0 {
                vm.removeNote(withID: note.id)
            } else {
                vm.updateNote(note: note)
            }
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .background || newValue == .inactive {
                if note.attributedText.string.count > 0 {
                    vm.updateNote(note: note)
                }
            }
        }
        .onAppear {
            if let note = vm.notes.first(where: {$0.id == selectedNoteID}) {
                self.note = note
            }
        }
    }
}

struct NoteEditor_Previews: PreviewProvider {
    static var previews: some View {
        NoteEditor(selectedNoteID: .constant(""))
            .environmentObject(NotesViewModel())
            .environmentObject(EditorSettingsViewModel())
    }
}

// MARK: - Top Toolbar
extension NoteEditor {
    func topToolBar(note: Note) -> some View {
        HStack {
            VStack(alignment: .trailing, spacing: 6){
                Text("\(note.wordsCount) words")
                    .font(.subheadline)
                Text("\(note.date.dateToString(formatString: "d.MM.YY, E HH:mm "))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            PinButton(note: $note)
        }
    }
}
// MARK: - ImageViwer
extension NoteEditor {
    private var imageViwer: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: dismiss ? 10 : 15) {
                ForEach(note.images, id: \.self) { uiImage in
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(dismiss ? 5 : 10)
//                        .matchedGeometryEffect(id: uiImage.hashValue, in: animation)
                }
            }
        }
        .frame(height: dismiss ? 35 : 50)
        .transition(.move(edge: .bottom))
        .animation(.easeInOut, value: dismiss)
    }
}
