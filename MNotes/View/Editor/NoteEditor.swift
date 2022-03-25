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
    @FocusState private var dismiss: Bool
    
    @State private var showCategoryPicker: Bool = false
    @State private var category: NoteCategory?
    
    @State private var note: Note = .init()
    @State private var deletionAlert: Bool = false
    var body: some View {
//        if let currentID = vm.notes.firstIndex(where: { $0.id == selectedNoteID } ) {
            VStack(spacing: 0){
                UITextEditor(attributedString: $note.attributedText)
                    .focused($dismiss)
                    .padding()
                Spacer(minLength: 0)
                EditorSettingsView()
                    .ignoresSafeArea()
                    .opacity(settings.showTextSettings ? 1 : 0)
                    .animation(.easeInOut, value: settings.showTextSettings)
                    .transition(.move(edge: .bottom))
                if dismiss {
                    editMenuBar
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .background(Color(UIColor.secondarySystemBackground).opacity(0.7).ignoresSafeArea(.keyboard, edges: .bottom))
                }

            }
            .overlay(CategoryPickerSelector(show: $showCategoryPicker, category: $note.category, size: 20, categoryPosition: .vertical), alignment: .topTrailing)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    topToolBar(note: note)
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    if !dismiss { editMenuBar }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
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
                    if note.attributedText.characters.count > 0 {
                        vm.updateNote(note: note)
                    }
                }
            }
            .onAppear {
                if let note = vm.notes.first(where: {$0.id == selectedNoteID}) {
                    self.note = note
                }
            }
//        }

    }
}

struct NoteEditor_Previews: PreviewProvider {
    static var previews: some View {
        NoteEditor(selectedNoteID: .constant(""))
            .environmentObject(NotesViewModel())
            .environmentObject(EditorSettingsViewModel())
    }
}

// MARK: - Main Edit Bar
// Custom button
struct CustomEditBarButton: View {
    
    let systemIconName: String?
    let title: String?
    let action: () -> Void
    
    var body: some View{
        Button {
            action()
        } label: {
            VStack{
                if let systemIconName = systemIconName { Image(systemName: systemIconName) } else { Text("Button") }
                if let title = title { Text("\(title)") }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}
// Main Edit buttons
extension NoteEditor {
    private var editMenuBar: some View {
        
        HStack{
            CustomEditBarButton(systemIconName: "chevron.left", title: nil) {
                presentationMode.wrappedValue.dismiss()
            }
            Group {
                CustomEditBarButton(systemIconName: "textformat.alt", title: nil) {
                    settings.showTextSettings.toggle()
                    dismiss = false
                }
                CustomEditBarButton(systemIconName: "trash", title: nil) {
                    deletionAlert.toggle()
                }
                .alert(isPresented: $deletionAlert) {
                    Alert(title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to clean all text?"),
                        primaryButton: .destructive(Text("Delete")) {
                        note.attributedText = ""
                        },
                        secondaryButton: .cancel())
                }
            }
            
            Button {
                dismiss.toggle()
            } label: {
                Text("\(dismiss ? "Done" : "Edit")")
                    .padding()
            }
            .frame(maxWidth: .infinity)
        }

    }
}

// MARK: - Top Toolbar
extension NoteEditor {
    private func topToolBar(note: Note) -> some View {
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
