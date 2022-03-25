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
//                self.dummyText() // ! DUMMMY TEXT : REMOVE IT IN PRODUCTION !
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

    ///Dumy data
    func dummyText() {

        let aStr = AttributedString("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. \n Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,", attributes: Note.defaultAttributes())
        let note1 = Note(attributedText: aStr, isPinned: true, category: .orange)
        notes.insert(note1, at: 0)
        

        let aStr2 = AttributedString("""
abc def ghi jkl mno pqrs tuv wxyz ABC DEF GHI JKL MNO PQRS TUV WXYZ !"§ $%& /() =?* '<> #|; ²³~ @`´ ©«» ¤¼× {} abc def ghi jkl mno pqrs tuv wxyz ABC DEF GHI JKL MNO PQRS TUV WXYZ !"§ $%& /() =?* '<> #|; ²³~ @`´ ©«» ¤¼× {} abc def ghi jkl mno pqrs tuv wxyz ABC DEF GHI JKL MNO PQRS TUV WXYZ !"§ $%& /() =?* '<> #|; ²³~ @`´ ©«» ¤¼× {} abc def ghi jkl mno pqrs tuv wxyz ABC DEF GHI JKL MNO PQRS TUV WXYZ !"§ $%& /() =?* '<> #|; ²³~ @`´ ©«» ¤¼× {} abc def ghi jkl mno pqrs tuv wxyz ABC DEF GHI JKL MNO PQRS TUV WXYZ !"§ $%& /() =?* '<> #|; ²³~ @`´ ©«» ¤¼× {} abc def ghi jkl mno pqrs tuv wxyz ABC DEF GHI JKL MNO PQRS TUV WXYZ !"§ $%& /() =?* '<> #|; ²³~ @`´ ©«» ¤¼× {} abc def ghi jkl mno pqrs tuv wxyz ABC DEF GHI JKL MNO PQRS TUV WXYZ !"§ $%& /() =?* '<> #|; ²³~ @`´ ©«» ¤¼× {}abc def ghi jkl mno pqrs tuv wxyz ABC DEF GHI
""", attributes: Note.defaultAttributes())
        let note2 = Note(attributedText: aStr2, isPinned: true, category: .green)
        notes.insert(note2, at: 0)
        
        
        let aStr3 = AttributedString("""
        Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.

        Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.

        Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.

        Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?

        At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere
        """, attributes: Note.defaultAttributes())
        let note3 = Note(attributedText: aStr3, isPinned: true, category: .red)
        notes.insert(note3, at: 0)
    }
}

