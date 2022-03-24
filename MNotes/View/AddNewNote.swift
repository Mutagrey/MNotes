//
//  AddNewNote.swift
//  MNotes
//
//  Created by Sergey Petrov on 20.03.2022.
//

import SwiftUI

struct AddNewNote: View {
    @EnvironmentObject var vm: NotesViewModel

    @Binding var showCategoryPicker: Bool //= false
    @State private var showButtonAnimation: Bool = false
    @State private var category: NoteCategory?
    
    var body: some View {
        VStack(spacing: 0.0) {
            CategoryPicker(show: $showCategoryPicker, category: $category)
                .scaleEffect(showButtonAnimation ? 1.05 : 1)
                .zIndex(0)
                .clipped()
            Button {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                    showCategoryPicker.toggle()
                    showButtonAnimation.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring()){
                        showButtonAnimation.toggle()
                    }
                }
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .padding()
                    .foregroundColor(Color.white)
                    .scaleEffect(showButtonAnimation ? 1.1 : 1)
                    .background(Color(UIColor.systemIndigo))
                    .clipShape(Circle())
            }
            .rotationEffect(.init(degrees: showCategoryPicker ? 45 : 0))
            .scaleEffect(showButtonAnimation ? 1.1 : 1)
            .zIndex(1)
        }
        .padding(.bottom)
        .transition(.move(edge: .bottom))
        .onChange(of: category) { newValue in
            // 1. Create new Note with selected category and add to notes
            // 2. Select Note ID
            if let newCategory = newValue {
                let newNote = vm.createNote(note: .init(category: newCategory), at: 0)
                print("NewNote ID: \(newNote.id)")
                vm.selectedNoteID = newNote.id
            }
        }
    }
}

struct AddNewNote_Previews: PreviewProvider {
    static var previews: some View {
        AddNewNote(showCategoryPicker: .constant(true))
            .environmentObject(NotesViewModel())
    }
}
