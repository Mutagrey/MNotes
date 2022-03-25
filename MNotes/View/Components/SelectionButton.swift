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
//    @AppStorage("fontSize") var fontSize: Double = 13
    var note: Note
    
    var body: some View{
        if vm.isEditable {
            Image(systemName: vm.isSelected(note: note) ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundColor(Color(UIColor.systemIndigo))
                .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
                .mask(Circle())
                .padding(10)
        }
    }
}

struct SelectionButtons_Previews: PreviewProvider {
    static var previews: some View {
        SelectionButton(note: .init())
    }
}
