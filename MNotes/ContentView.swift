//
//  ContentView.swift
//  MNotes
//
//  Created by Sergey Petrov on 15.03.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NotesViewModel())
            .environmentObject(EditorSettingsViewModel())
    }
}
