//
//  ContextMenu.swift
//  MNotes
//
//  Created by Sergey Petrov on 21.03.2022.
//

import SwiftUI

struct ContextMenu: View {
    @EnvironmentObject var vm: NotesViewModel
    @Binding var note: Note
    
    var body: some View {
        VStack{
            ShareButton(items: [note.attributedText.string]) {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            Button {
                note.isPinned.toggle()
                vm.updateNote(note: note)
            } label: {
                Label(note.isPinned ? "Unpin" : "Pin", systemImage: note.isPinned ? "pin.fill" : "pin")
            }
            
            Divider()
            
            Button(role: .destructive) {
                vm.removeNote(withID: note.id)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            

        }
    }
}

struct ContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        ContextMenu(note: .constant(.init()))
            .environmentObject(NotesViewModel())
    }
}

struct MenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
      configuration.label
        .padding()
        .foregroundColor(.purple)
        .background(configuration.isPressed ? Color.green : Color.blue)
        .cornerRadius(8.0)
    }
}
