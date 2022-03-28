//
//  NoteEditor+SettingsBar.swift
//  MNotes
//
//  Created by Sergey Petrov on 26.03.2022.
//

import Foundation
import SwiftUI



//MARK: - Main Edit Bar
extension NoteEditor {
    
    var editBar: some View {
        VStack(spacing: 0){
            textSettings
                .ignoresSafeArea()
                .opacity(settings.showTextSettings ? 1 : 0)
                .animation(.easeInOut, value: settings.showTextSettings)
                .transition(.move(edge: .bottom))
            if dismiss {
                editMenuBar
                    .background(Color(UIColor.secondarySystemBackground).opacity(0.7).ignoresSafeArea(.keyboard, edges: .bottom))
            }
        }

    }
}

//MARK: - Text Settings
extension NoteEditor {
    
    @ViewBuilder
    var textSettings: some View {
        if settings.showTextSettings {
            VStack(spacing: 15.0) {
                HStack {
                    titleSetting(title: "Text")
                    Spacer()
                    closeButton
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                FontFromatView()
                Divider()
            }
            .padding(.bottom)
            .background(Color(UIColor.secondarySystemBackground))
        }
    }
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

//MARK: - Menu Bar
extension NoteEditor {
    
    // custom edit bar button
    private func customEditBarButton(systemIconName: String?, title: String?,  action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            VStack{
                if let systemIconName = systemIconName { Image(systemName: systemIconName) } else { Text("Button") }
                if let title = title { Text("\(title)") }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
    
    // edit menu bar
    var editMenuBar: some View {
        
        HStack{
            Group {
                customEditBarButton(systemIconName: "chevron.left", title: nil) {
                    presentationMode.wrappedValue.dismiss()
                }
                customEditBarButton(systemIconName: "textformat.alt", title: nil) {
                    settings.showTextSettings.toggle()
                    dismiss = false
                }
            }
            .transition(.move(edge: .leading))
            
            if settings.showApplyCurrentAttributesButton {
                Button("Apply") {
                    settings.applyCurrentAttributes = true
                    
//                    if let index = vm.notes.firstIndex(where: {$0.id == vm.selectedNoteID }) {
//                        if let range = vm.notes[index].attributedText.range(of: settings.selectedText) {
//                            vm.notes[index].attributedText[range].mergeAttributes(settings.currentAttributes)
//                            settings.applyCurrentAttributes = false
//                        }
//                    }
                    
                }
                .frame(maxWidth: .infinity)
                .transition(.scale)
                .opacity(settings.showApplyCurrentAttributesButton ? 1 : 0)
            }
            
            Group {
                customEditBarButton(systemIconName: "trash", title: nil) {
                    dismiss = false
                    deletionAlert.toggle()
                }
                .alert(isPresented: $deletionAlert) {
                    Alert(title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to clean all text?"),
                        primaryButton: .destructive(Text("Delete")) {
                        note.attributedText = ""
                        },
                        secondaryButton: .cancel())
                }
                Button {
                    dismiss.toggle()
                } label: {
                    Text("\(dismiss ? "Done" : "Edit")")
                        .padding()
                }
                .frame(maxWidth: .infinity)
            }
            .transition(.move(edge: .trailing))

        }
        .animation(.easeInOut, value: settings.showApplyCurrentAttributesButton)

    }
}
