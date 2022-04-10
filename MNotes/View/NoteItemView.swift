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
        
    @State private var showCategoryPicker: Bool = false
    
    private let cornerRadius: CGFloat = 17
    
    init(note: Binding<Note>, maxHeight: CGFloat = 100, categoryPosition: CategoryPosition = .vertical, categorySize: CGFloat = 13) {
        self._note = note
        self.maxHeight = maxHeight
        self.categoryPosition = categoryPosition
        self.categorySize = categorySize
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            gridView
            CategoryPickerSelector(show: $showCategoryPicker, note: $note, size: categorySize, categoryPosition: categoryPosition)
                .allowsHitTesting(!vm.isEditable)
                // it doesnt work...need to fix......
                .onChange(of: note) { newValue in
                    print("cur category \(newValue.category?.rawValue ?? "")")
                    vm.updateNote(note: newValue)
                }
        }
        .background{
            ZStack{
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
//                    .shadow(color: Color.white.opacity(0.7), radius: 8, x: -5, y: -5)
                    .shadow(color: Color.black.opacity(0.7), radius: 5, x: 5, y: 5)
                    .blendMode(.overlay)
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.theme.noteColor)
            }
        }
        .overlay{
            RadialGradient(colors: [
                Color.theme.buttonColor.opacity(0.5),
                Color.clear
            ], center: .bottomTrailing, startRadius: 0, endRadius: vm.isEditable ? 500 : 0)
            .opacity(vm.isEditable ? 0.4 : 0)
            .cornerRadius(cornerRadius)
            .animation(.easeInOut, value: vm.isEditable)
        }
        .overlay(SelectionButton(note: note), alignment: .bottomTrailing)
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
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(Color.accentColor)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            ScrollView(.vertical, showsIndicators: false) {
                if note.images.count > 0 { imageView }
                Text(AttributedString(note.subtitle))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer(minLength: 0)
            Text("\(note.date.dateToString(formatString: "d.MM.y, E HH:mm"))")
                .foregroundColor(Color.secondary)
                .font(.system(size: 12, weight: .light, design: .rounded))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, idealHeight: maxHeight, maxHeight: maxHeight, alignment: .leading)
        .padding(10)
        .background(Color.theme.noteColor)
        .cornerRadius(cornerRadius)
    }
    
    private var imageView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(note.images, id: \.self) { uiImage in
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(5)
                }
            }
        }
        .frame(height: 50)
    }
}



