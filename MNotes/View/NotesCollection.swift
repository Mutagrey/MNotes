//
//  NotesList.swift
//  MNotes
//
//  Created by Sergey Petrov on 15.03.2022.
//

import SwiftUI

struct NotesCollection: View {
    @EnvironmentObject var vm: NotesViewModel
    @Namespace var animation
    
    @State private var showPinnedCollection: Bool = true
    
    @AppStorage("padding") var padding: Double = 3
    @AppStorage("columns") var columnsNum: Int = 2
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columnsNum), spacing: padding, pinnedViews: [.sectionHeaders]) {
                Section(header: headerView.padding(.horizontal, -15)) { }
                ForEach(NoteCategory.allCases, id: \.self) { category in
                    if vm.notes.filter({$0.category == category}).count > 0 {
                        Section(header: categoryHeaderView(category: category)) {
                            content(category: category)
                        }
                    }
                }
            }
        }
    }
}

struct NotesList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
        .environmentObject(NotesViewModel())
        .environmentObject(EditorSettingsViewModel())
    }
}

// MARK: - Content
extension NotesCollection {
    /// Row Element View
    private func content(category: NoteCategory) -> some View {
        ForEach(vm.notes.filter({$0.category == category})) { note in
            if let noteID = vm.notes.firstIndex(where: {$0.id == note.id}) {
                Group{
                    if vm.isEditable {
                        NoteItemView(note: $vm.notes[noteID], categoryPosition: .vertical)
                            .onTapGesture {
                                vm.toggleSelected(note: note)
                            }
                    } else {
                        NavigationLink(tag: vm.notes[noteID].id, selection: $vm.selectedNoteID) {
                            NoteEditor(selectedNoteID: $vm.selectedNoteID)
                        } label: {
                            NoteItemView(note: $vm.notes[noteID], categoryPosition: .vertical)
                        }

                    }
                }
                .matchedGeometryEffect(id: note.id, in: animation) 
                .padding(.vertical, padding)
            }
        }
    }
}

// MARK: - Headers for LazyVGrid
extension NotesCollection {
    private var headerView: some View{
        VStack{
            HStack {
                Text("Pinned Notes")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                Spacer()
                Button {
                    withAnimation(.spring()) {
                        showPinnedCollection.toggle()
                    }
                } label: {
                    HStack{
                        let count = vm.notes.filter({$0.isPinned}).count
                        Image(systemName: "chevron.right")
                            .frame(width: 15, height: 15)
                            .rotationEffect(.init(degrees: (showPinnedCollection && count > 0) ? 90 : 0))
                            .foregroundColor(count == 0 ? Color.gray : Color.accentColor)
                        Text("\(count)")
                            .foregroundColor(count == 0 ? Color.gray : Color.accentColor)
                        Image(systemName: count == 0 ? "pin" : "pin.fill")
                            .foregroundColor(Color(UIColor.systemIndigo))
                            .font(.headline)
                    }
                    .font(.subheadline)
                    .padding(5)
                    .padding(.horizontal, 8)
                    .background(Color(UIColor.secondarySystemFill))
                    .mask(Capsule())
                }
            }
            .padding(.horizontal)
            if showPinnedCollection {
                TabViewNotes()
                    .frame(height: showPinnedCollection ? nil : 0)
                    .opacity(showPinnedCollection ? 1 : 0)
            }
        }
        .background(Color(UIColor.systemBackground))
        .clipped()
    }
    
    private func categoryHeaderView(category: NoteCategory) -> some View{
        HStack {
            Circle()
                .fill(category.color)
                .frame(width: 9, height: 9)
            Text("\(category.rawValue.capitalized)")
                .font(.caption)
                .foregroundColor(Color.primary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal)
        .background(Color(UIColor.systemBackground).opacity(0.5))
        .clipShape(Capsule())
    }
}
