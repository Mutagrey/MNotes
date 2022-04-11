//
//  TabViewNotes.swift
//  MNotes
//
//  Created by Sergey Petrov on 18.03.2022.
//

import SwiftUI

struct TabViewNotes: View {
    @EnvironmentObject var vm: NotesViewModel
    @State private var selectedNoteID: String = ""
    private let maxHeight: CGFloat = UIScreen.main.bounds.height / 3.6
    var body: some View {
        if vm.filteredNotes.filter({ $0.isPinned }).count > 0 {
            TabView(selection: $selectedNoteID) {
                ForEach($vm.filteredNotes.filter({ $0.isPinned.wrappedValue })) { $note in
                    Button {
                        if vm.isEditable {
                            vm.toggleSelected(note: note)
                        } else {
                            vm.selectedNote = note
                            withAnimation(.easeInOut) {
                                vm.showDetailView = true
                            }
                        }
                    } label: {
                        NoteItemView(note: $note, maxHeight: maxHeight, categoryPosition: .horizontal, categorySize: 18)
                            .tag(note.id)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: maxHeight)
        }
    }
}
