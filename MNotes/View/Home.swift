//
//  Home.swift
//  MNotes
//
//  Created by Sergey Petrov on 19.03.2022.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var vm: NotesViewModel
    
    @State private var showCategoryPicker: Bool = false
    @State private var showSettings: Bool = false
    @AppStorage("sortBy") var sortBy: SortBy = .category
//    @State private var deletionAlert: Bool = false
    
    var body: some View {
        NavigationView {
            NotesCollection()
                .transition(.move(edge: .bottom))
                .padding(.horizontal, 10)
                .navigationBarTitle("My Notes")
                .navigationBarHidden(showCategoryPicker)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        editButton
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                            bottomToolbar
                    }
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        settingsButton
                    }
                }
                .overlay(BlurView(effect: .systemUltraThinMaterialDark).opacity(showCategoryPicker ? 1 : 0).ignoresSafeArea().onTapGesture{ withAnimation(.spring()) { showCategoryPicker.toggle() } })
                .overlay(ZStack{ if !vm.isEditable { AddNewNote(showCategoryPicker: $showCategoryPicker) } }, alignment: .bottomTrailing)
                .animation(.easeInOut, value: vm.isEditable)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Notes")
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
//        .overlay(Text("\(vm.selectedNoteID ?? "empty")"))
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Home()
                .preferredColorScheme(.dark)
                .environmentObject(NotesViewModel())
            Home()
                .environmentObject(NotesViewModel())
        }
    }
}

// MARK: - ToolBar Buttons
extension Home {
    
    // Bootom toolbar
    private var bottomToolbar: some View {
        HStack{
            if vm.isEditable {
                cancelButton
                    .transition(.move(edge: .leading))
                Spacer()
                removeButton
                    .transition(.move(edge: .trailing))
            } else {
                if !showCategoryPicker {
//                    sortByMenu
//                        .transition(.move(edge: .leading))
//                    Spacer()
                    notesCount
                        .opacity(vm.isEditable ? 0 : 1)
                        .transition(.scale)
//                    Spacer()
//                    Button("") {}
                }
            }
        }
        .opacity(showCategoryPicker ? 0 : 1)
    }
    
    // Edit Collection Button
    private var settingsButton: some View {
        HStack{
            if !showCategoryPicker {
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gear")
                        .padding()
                }
                .transition(.move(edge: .leading))
            }
        }
        .opacity(showCategoryPicker ? 0 : 1)
    }
    
    // Edit Collection Button
    private var editButton: some View {
        HStack{
            if !showCategoryPicker {
                Button {
                    vm.isEditable.toggle()
                } label: {
                    Text(vm.isEditable ? "Done" : "Edit")
                        .font(.headline.bold())
                        .padding()
                }
                .transition(.move(edge: .trailing))
            }
        }
        .opacity(showCategoryPicker ? 0 : 1)
    }
    // NotesCount
    private var notesCount: some View {
        VStack{
            Text("\(vm.notes.count) notes")
                .font(.caption)
        }
    }
    // Cancel Button
    private var cancelButton: some View {
        Button {
            vm.selectedNotes.removeAll()
            vm.isEditable.toggle()
        } label: {
            Text("Cancel")
                .padding()
        }
    }
    // Remove Button
    private var removeButton: some View {
        Button {
            vm.isDeletePressed.toggle()
        } label: {
            HStack {
                selectedCount
                Image(systemName: "trash")
                    .foregroundColor(vm.selectedNotes.count == 0 ? Color.gray : Color.red)
            }
            .padding(5)
            .padding(.horizontal)
            .background(Color(UIColor.secondarySystemFill))
            .mask(Capsule())
        }
        .disabled(vm.selectedNotes.count == 0)
        .alert(isPresented: $vm.isDeletePressed) {
            Alert(title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete selected Notes?"),
                primaryButton: .destructive(Text("Delete")) {
                vm.removeSelectedNotes()
                },
                secondaryButton: .cancel())
        }
    }
    // Selected Count
    @ViewBuilder
    private var selectedCount: some View {
        if vm.selectedNotes.count > 0 {
            Text("\(vm.selectedNotes.count)")
                .font(.subheadline.bold())
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Menu SortBy

enum SortBy: String, CaseIterable {
    case date
    case category
    
    var iconName: String {
        switch self {
        case .date:
            return "calendar"
        case .category:
            return "bookmark"
        }
//        paperclip
    }
}

extension Home {
    
    private var sortByMenu: some View {
//        Menu {
        HStack{
            if !showCategoryPicker {
                Picker(selection: $sortBy) {
                    ForEach(SortBy.allCases, id: \.self) { sortBy in
                        Button {
                            self.sortBy = sortBy
                            print(sortBy)
                        } label: {
                            Label("\(sortBy.rawValue.capitalized)", systemImage: sortBy.iconName)
                                .padding()
                                .font(.caption2)
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
//                        .font(.caption2)
                }
                
                .pickerStyle(MenuPickerStyle())
                .transition(.move(edge: .leading))
            }
        }
        .opacity(showCategoryPicker ? 0 : 1)

    }
}
