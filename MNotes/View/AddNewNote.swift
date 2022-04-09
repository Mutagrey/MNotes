//
//  AddNewNote.swift
//  MNotes
//
//  Created by Sergey Petrov on 20.03.2022.
//

import SwiftUI

struct AddNewNote: View {
    @EnvironmentObject var vm: NotesViewModel

    @Binding var showCategoryPicker: Bool
    @State private var showButtonAnimation: Bool = false
    @State private var category: NoteCategory?
    
    var body: some View {
        VStack(spacing: 0.0) {
            CategoryPicker(show: $showCategoryPicker, category: $category, transition: .bottom)
                .scaleEffect(showButtonAnimation ? 1.1 : 1)
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
                    .clipShape(Circle())
                    .rotationEffect(.init(degrees: showCategoryPicker ? 45 : 0))
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(colors: [Color.theme.buttonColor.opacity(0.8), Color.theme.buttonColor.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: showButtonAnimation ? 6 : 4)
                    )
            }
            .scaleEffect(showButtonAnimation ? 1.1 : 1)
            .zIndex(1)
            .background(
                ZStack{
                    Circle()
//                        .shadow(color: Color.black.opacity(0.7), radius: 5, x: -5, y: -5)
                        .shadow(color: Color.black.opacity(0.7), radius: 5, x: 5, y: 5)
                        .blendMode(.overlay)
                    Circle()
                        .fill(Color.theme.buttonColor)
                }
            )
        }
        .padding()
        .transition(.move(edge: .bottom))
        .onChange(of: category) { newValue in
            if let newCategory = newValue {
                let newNote = vm.createNote(note: .init(category: newCategory), at: 0)
                print("NewNote ID: \(newNote.id)")
                vm.selectedNote = newNote
                withAnimation(.easeInOut) {
                    vm.showDetailView = true
                }
                category = nil
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
