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
    @AppStorage("fontSize") var fontSize: Double = 13
    
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
            //                .overlay(PinnedButtonView(note: $note).offset(y: -20), alignment: .topTrailing)
            CategoryPickerSelector(show: $showCategoryPicker, category: $note.category, size: categorySize, categoryPosition: categoryPosition)
                .zIndex(1)
//                .overlay(CategoryPickerSelector(show: $showCategoryPicker, category: $note.category, size: categorySize, categoryPosition: categoryPosition), alignment: .topTrailing)
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
                 .font(.system(size: fontSize + 2, weight: .semibold, design: .rounded))
                 .foregroundColor(Color.accentColor)
                 .multilineTextAlignment(.leading)
                 .lineLimit(2)
             ScrollView(.vertical, showsIndicators: true) {
                 Text(note.attributedText)
//                     .font(Font(UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .regular))
//                     .font(.system(size: fontSize, weight: .regular))
//                     .foregroundColor(Color.primary)
                     .multilineTextAlignment(.leading)
             }
             Spacer(minLength: 0)
             Text("\(note.date.dateToString(formatString: "d.MM.y, E HH:mm"))")
                 .foregroundColor(Color.secondary)
                 .font(.system(size: fontSize - 2, weight: .light, design: .rounded))
                 .lineLimit(1)
         }
         .frame(maxWidth: .infinity, idealHeight: maxHeight, maxHeight: maxHeight, alignment: .leading)
         .padding(10)
         .background(Color(UIColor.secondarySystemBackground))
         .cornerRadius(cornerRadius)
     }
 }

// MARK: - Selected Note View
struct SelectionButton: View {
    @EnvironmentObject var vm: NotesViewModel
    @AppStorage("fontSize") var fontSize: Double = 13
    var note: Note
    
    var body: some View{
        if vm.isEditable {
            Image(systemName: vm.isSelected(note: note) ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundColor(Color(UIColor.systemIndigo))
                .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
                .mask(Circle())
                .padding(fontSize / 2)
        }
    }
}

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



