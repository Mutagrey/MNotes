//
//  EditorSettingsView.swift
//  MNotes
//
//  Created by Sergey Petrov on 19.03.2022.
//

import SwiftUI

struct EditorSettingsView: View {
    @EnvironmentObject var settings: EditorSettingsViewModel
    
    var body: some View {
        if settings.showEditorSettings {
            VStack(spacing: 0.0) {
                HStack {
                    titleSetting(title: "Text")
                    Spacer()
                    closeButton
                }
                FontFromatView()
            }
            .frame(height: 200)
            .background(Color(UIColor.quaternarySystemFill))
        }
    }
}

struct EditorSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        EditorSettingsView()
    }
}

extension EditorSettingsView {
    // Close Button
    private var closeButton: some View{
        Button {
            settings.showEditorSettings.toggle()
        } label: {
            Image(systemName: "xmark")
                .padding()
                .foregroundColor(Color.secondary)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Circle())
        }
        .padding()
    }
    // Title
    private func titleSetting(title: String) -> some View {
        Text("\(title.capitalized)")
            .font(.title2)
            .fontWeight(.bold)
            .padding()
    }
    
}

