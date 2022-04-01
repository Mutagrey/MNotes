//
//  NoteItemView.swift
//  MNotes
//
//  Created by Sergey Petrov on 17.03.2022.
//

import SwiftUI

struct NoteItemView: View {
    @EnvironmentObject var vm: NotesViewModel
    @Binding var note: Note
    let maxHeight: CGFloat
    let categoryPosition: CategoryPosition
    let categorySize: CGFloat
    
    @AppStorage("cornerRadius") var cornerRadius: Double = 12
    
    @State private var showCategoryPicker: Bool = false
    @State private var category: NoteCategory?
    
    init(note: Binding<Note>, maxHeight: CGFloat = 100, categoryPosition: CategoryPosition = .vertical, categorySize: CGFloat = 13) {
        self._note = note
        self.maxHeight = maxHeight
        self.categoryPosition = categoryPosition
        self.categorySize = categorySize
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            gridView
                .overlay(SelectionButton(note: note), alignment: .bottomTrailing)
            CategoryPickerSelector(show: $showCategoryPicker, category: $note.category, size: categorySize, categoryPosition: categoryPosition)
                .zIndex(1)
        }
        .onChange(of: note.category) { newValue in
            print("\(newValue?.rawValue ?? "ff")")
            vm.updateNote(note: note)
        }
        .contextMenu { ContextMenu(note: $note) }


    }
    
}

struct NoteItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NoteItemView(note: .constant(.init()))
                .previewLayout(.sizeThatFits)
            NoteItemView(note: .constant(.init()))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
        .environmentObject(NotesViewModel())
    }
}

// MARK: - LazyVGrid View Style

 extension NoteItemView {
     private var gridView: some View {
         VStack(alignment: .leading, spacing: 3){
             Text("\(note.title)")
                 .font(.system(size: 16, weight: .semibold, design: .rounded))
                 .foregroundColor(Color.accentColor)
                 .multilineTextAlignment(.leading)
                 .lineLimit(2)
             ScrollView(.vertical, showsIndicators: true) {
                 Text(AttributedString(note.subtitle))
                     .multilineTextAlignment(.leading)
             }
             Spacer(minLength: 0)
             Text("\(note.date.dateToString(formatString: "d.MM.y, E HH:mm"))")
                 .foregroundColor(Color.secondary)
                 .font(.system(size: 12, weight: .light, design: .rounded))
                 .lineLimit(1)
         }
         .frame(maxWidth: .infinity, idealHeight: maxHeight, maxHeight: maxHeight, alignment: .leading)
         .padding(10)
         .background(Color(UIColor.secondarySystemBackground))
         .cornerRadius(cornerRadius)
     }
 }



