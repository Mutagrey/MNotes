//
//  MNotesApp.swift
//  MNotes
//
//  Created by Sergey Petrov on 15.03.2022.
//

import SwiftUI

@main
struct MNotesApp: App {
    @StateObject var vm = NotesViewModel()
    @StateObject var editSettings = EditorSettingsViewModel()
    
//    init() {
//        UINavigationBar.appearance().items?.append()
//    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .environmentObject(editSettings)
        }
    }
}
