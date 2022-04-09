//
//  SelectionButtons.swift
//  MNotes
//
//  Created by Sergey Petrov on 25.03.2022.
//

import SwiftUI

// MARK: - Selected Note View
struct SelectionButton: View {
    @EnvironmentObject var vm: NotesViewModel

    var note: Note
    
    var body: some View{
        VStack{
            if vm.isEditable {
                Image(systemName: vm.isSelected(note: note) ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
//                    .foregroundColor(Color.theme.buttonColor)
                    .foregroundColor(vm.isSelected(note: note) ? Color.theme.buttonColor : Color.white.opacity(0.7))
                    .background(vm.isSelected(note: note) ? Color.white : Color.clear)
                    .mask(Circle())
                    .padding(10)
                    .opacity(vm.isEditable ? 1 : 0)
                    .transition(.scale)
            }
            
        }
        .animation(.easeInOut, value: vm.isEditable)
    }
}

struct SelectionButtons_Previews: PreviewProvider {
    static var previews: some View {
        SelectionButton(note: .init())
    }
}
