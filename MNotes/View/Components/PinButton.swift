//
//  PinButton.swift
//  MNotes
//
//  Created by Sergey Petrov on 25.03.2022.
//

import SwiftUI

// MARK: - Pinned Note View
struct PinButton: View {
    @EnvironmentObject var vm: NotesViewModel
    @Binding var note: Note

    var body: some View{
        Button {
            note.isPinned.toggle()
            vm.updateNote(note: note)
        } label: {
            Image(systemName: note.isPinned ? "pin.fill" : "pin")
                .foregroundColor(Color(UIColor.systemIndigo))
//                .padding()
        }
    }
}

struct PinButton_Previews: PreviewProvider {
    static var previews: some View {
        PinButton(note: .constant(.init()))
    }
}
