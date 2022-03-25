//
//  NotesViewModel.swift
//  MNotes
//
//  Created by Sergey Petrov on 15.03.2022.
//

import SwiftUI
import Combine

/* CRUD functions
 Create
 Read
 Update
 Delete
 */

class NotesViewModel: ObservableObject {
    
    @Published var notes: [Note] = [] // All availible Notes
    
    @Published var selectedNotes: [Note] = [] // Notes for deletion
    @Published var selectedNoteID: String? // Selected Note ID for NavigationLink
    
    @Published var searchText: String = "" // Searchable text
    
    @Published var isDeletePressed: Bool = false
    @Published var isEditable: Bool = false
    
    let dataService = NotesDataService.instance // manager that loads notes from local folders
    
    private var noteCancelables = Set<AnyCancellable>() // cancellables for notes
    
    init() {
        readNotes()
    }
}

// MARK: - Update Selected Note Attributes
extension NotesViewModel {
    func updateSelectedNoteAttributes() {
        
    }
}

// MARK: - CRUD methods
extension NotesViewModel {
    /// Create new Node and save it to local folder
    @discardableResult
    func createNote(note: Note = .init(), at index: Int = 0 ) -> Note {
        notes.insert(note, at: index) // insert New Note to first position
//        dataService.notes.insert(note, at: index) // add to dataservise to correctly update searchable info ????? DOESNT WORK 
        return note
    }
    /// Read Notes from local folders.
    /// Filter by search text
    /// Add Info Note
    func readNotes() {
        $searchText
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .combineLatest(dataService.$notes)
            .map{ (text, notes) -> [Note] in
                guard !text.isEmpty else { return notes }
                let lowercasedText = text.lowercased()
                let filteredData = notes.filter({ (element) -> Bool in
                    element.attributedText.description.lowercased().contains(lowercasedText) //||
//                    element.title.lowercased().contains(lowercasedText)
                })
                return filteredData
            }
            .sink { [weak self] (returnedNotes) in
                guard let self = self else { return }
                self.notes = returnedNotes.sorted(by: { $0.date > $1.date })
            }
            .store(in: &noteCancelables)
    }
    /// Update Node and save it to local folder
    func updateNote(note: Note) {
        if let noteID = notes.firstIndex(where: { $0.id == note.id }) {
            notes[noteID] = note
            print("[📝] Updated note: \(note.id) with title: \(note.title)")
        }
        dataService.saveNote(note: note)
    }
    /// Delete selected Nodes and remove them from local folder
    func removeSelectedNotes() {
        // 1. Remove selected Notes from `notes`
        selectedNotes.forEach { note in
            notes.removeAll(where: { $0.id == note.id })
        }
        // 2. Remove selected Notes folders
        selectedNotes.forEach { note in
            LocalFileManager.removeURL(url: note.folderURL)
        }
        // 3. Remove selected Notes from `notes`
        selectedNotes.removeAll()
        
        // 4. Add Info Note if needed
        if notes.count == 0 {
            createNote(note: dataService.getInfoNote())
        }
        // 5. Toogle Editable
        isEditable = false
    }
    /// Delete Note by ID
    func removeNote(withID id: String) {
        // 1. Remove from local folder
        notes.filter({ $0.id == id }).forEach { note in
            LocalFileManager.removeURL(url: note.folderURL)
        }
        // 2. Remove from `notes`
        notes.removeAll(where: { $0.id == id })

        // 3. Add Info Note if needed
        if notes.count == 0 {
            createNote(note: dataService.getInfoNote())
        }
        // 4. Toogle Editable
        isEditable = false
    }
}

// MARK: - Selection Notes
extension NotesViewModel {
    /// Toogle selection Note
    @discardableResult
    func toggleSelected(note: Note) -> Bool {
        if let index = selectedNotes.firstIndex(of: note) {
            selectedNotes.remove(at: index)
            return false
        } else {
            selectedNotes.append(note)
            return true
        }
    }
    // Checks if Note is selected
    func isSelected(note: Note) -> Bool {
        if selectedNotes.firstIndex(of: note) != nil {
            return true
        } else {
            return false
        }
    }
}
