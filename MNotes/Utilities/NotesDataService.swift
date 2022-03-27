//
//  NotesDataService.swift
//  MNotes
//
//  Created by Sergey Petrov on 17.03.2022.
//

import SwiftUI
import Combine

class NotesDataService {
    
    static let instance = NotesDataService()
    private init () { loadNotes() }
    
    @Published var notes: [Note] = []
    @Published var isLoading: Bool = false
    
    private var cancelables = Set<AnyCancellable>()
    
    /// Load All Nodes from local folder
    private func loadNotes() {
        isLoading = true
        let rootURL = LocalFileManager.rootURL
        do {
            // Get the directory contents urls (including subfolders urls)
            let folders = try FileManager.default.contentsOfDirectory(at: rootURL, includingPropertiesForKeys: nil)
            try folders.forEach { folder in
                // Get subfolders
                let subfolders = try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)
                // Get JSON files URLs
                let jsonURLs = subfolders.filter({ $0.isFileURL && $0.lastPathComponent.hasSuffix(".json") })
                // Load each JSON URL data and append it to notes
                jsonURLs.forEach { jsonURL in
                    loadNoteFromLocalURL(url: jsonURL)
                }
            }
            
            // Load additional data
            if folders.count == 0 {
                self.notes.append(self.getInfoNote())
                self.notes.forEach({ self.saveNote(note: $0) })
            }
            
            isLoading = false
        } catch let error{
            print("[📂] Error to get json: \(error.localizedDescription)")
            isLoading = false
        }
    }
    /// Load single Note from local folder and append it to `notes`.
    private func loadNoteFromLocalURL(url: URL) {
        LocalFileManager.getJSON(from: url)
            .decode(type: Note.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    print("[⚠️] Local data is empty...Loading from URL....\(url.path)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] note in
                guard let self = self else { return }
                self.notes.append(note)
                
            })
            .store(in: &cancelables)
    }
    
    /// Save Node to local folder
    func saveNote(note: Note) {
        // Gets JSON URL rootURL/<ID>/Note.json
        let jsonURL = note.folderURL.appendingPathComponent("Note.json")
        if !note.attributedText.characters.isEmpty {
            LocalFileManager.saveJSON(to: jsonURL, data: note)
        }
    }
    
}

// MARK: - Additional Loanding data
extension NotesDataService {

    /// Add First Info Note
    func getInfoNote() -> Note {
        var infoNote = Note()
        infoNote.attributedText = AttributedString("""
                This is the Note Info \r
                Tap to Edit this Note \r
                Features: \n
                - Edit note \r
                - Change font style \r
                - Change text color \r
                - Pin note \r
                - Choose color category for your Note
                """, attributes: Note.defaultAttributes())
        infoNote.attributedText.foregroundColor = UIColor.systemOrange
        infoNote.isPinned = true
        return infoNote
    }
}

