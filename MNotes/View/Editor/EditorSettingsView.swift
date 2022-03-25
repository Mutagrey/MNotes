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
        if settings.showTextSettings {
            VStack(spacing: 15.0) {
                HStack {
                    titleSetting(title: "Text")
                    Spacer()
//                    if settings.showApplyCurrentAttributesButton {
//                        Button("Apply") {
//                            settings.applyCurrentAttributes = true
//                        }
//                    }
//                    Spacer()
                    closeButton
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                FontFromatView()
//                    .padding()
                Divider()
            }
            .padding(.bottom)
            .background(Color(UIColor.secondarySystemBackground))
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
            settings.showTextSettings.toggle()
        } label: {
            Image(systemName: "xmark")
                .padding()
                .foregroundColor(Color.secondary)
                .background(Color(UIColor.secondarySystemFill))
                .clipShape(Circle())
        }
    }
    // Title
    private func titleSetting(title: String) -> some View {
        Text("\(title.capitalized)")
            .font(.title2)
            .fontWeight(.bold)
    }
    
}

