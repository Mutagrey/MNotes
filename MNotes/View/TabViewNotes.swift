//
//  TabViewNotes.swift
//  MNotes
//
//  Created by Sergey Petrov on 18.03.2022.
//

import SwiftUI

struct TabViewNotes: View {
    @EnvironmentObject var vm: NotesViewModel
    @State private var selectedNoteID: String = ""// = 1
    private let maxHeight: CGFloat = 250
    
    var body: some View {
        if vm.filteredNotes.filter({ $0.isPinned }).count > 0 {
            TabView(selection: $selectedNoteID) {
                ForEach(vm.filteredNotes.filter({ $0.isPinned })) { note in
                    if let noteID = vm.filteredNotes.firstIndex(where: {$0.id == note.id}) {
                        Group{
                            if vm.isEditable {
                                NoteItemView(note: $vm.filteredNotes[noteID], maxHeight: maxHeight, categoryPosition: .horizontal, categorySize: 20)
                                    .onTapGesture {
                                        vm.toggleSelected(note: note)
                                    }
                            } else {
                                NavigationLink(tag: vm.filteredNotes[noteID].id, selection: $vm.selectedNoteID) {
                                    NoteEditor(selectedNoteID: $vm.selectedNoteID)
                                } label: {
                                    NoteItemView(note: $vm.filteredNotes[noteID], maxHeight: maxHeight, categoryPosition: .horizontal, categorySize: 20)
                                }
                            }
                        }
                        .tag(noteID)
                        .padding(.horizontal)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: maxHeight)
            .onAppear{
                if let firstNote = vm.filteredNotes.filter({ $0.isPinned }).first {
                    if self.selectedNoteID == "" {
                        self.selectedNoteID = firstNote.id
                    }
                }
            }

        }
    }
}

struct TabViewNotes_Previews: PreviewProvider {
    static var previews: some View {
        TabViewNotes()
    }
}

