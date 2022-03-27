//
//  SettingsView.swift
//  MNotes
//
//  Created by Sergey Petrov on 21.03.2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("padding") var padding: Double = 3
    @AppStorage("cornerRadius") var cornerRadius: Double = 12
    @AppStorage("columns") var columns: Int = 2
//    @AppStorage("sortBy") var sortBy: SortBy = .category
    
    var body: some View {
        NavigationView {
            Form {
                mainSettings
            }
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                            .bold()
                            .padding()
                    }
                }
            }
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {

    @ViewBuilder
    private var mainSettings: some View {
        Section(header: Text("Main settings")) {
            
            VStack {
                Slider(value: $padding, in: 0...20, step: 1)
                HStack {
                    Text("Paddding")
                    Spacer()
                    Text("\(padding, specifier: "%.0f")")
                }
            }
            
            VStack {
                Slider(value: $cornerRadius, in: 0...20, step: 1)
                HStack {
                    Text("Corner Radius")
                    Spacer()
                    Text("\(cornerRadius, specifier: "%.0f")")
                }
            }
            
            Picker("Columns", selection: $columns) {
                ForEach(1...5, id: \.self) { index in
                    Text("\(index)").tag(index)
                }
            }
            
//            Picker("SortBy", selection: $sortBy) {
//                ForEach(SortBy.allCases, id: \.self) { sortBy in
//                    Text("\(sortBy.rawValue.capitalized)").tag(sortBy)
//                }
//            }

        }
    }
    
}
