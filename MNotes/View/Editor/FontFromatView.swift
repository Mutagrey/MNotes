//
//  FontView.swift
//  MNotes
//
//  Created by Sergey Petrov on 16.03.2022.
//

import SwiftUI

struct FontFromatView: View {
    @EnvironmentObject var settings: EditorSettingsViewModel
    
    
    var body: some View {
        VStack {
            HStack(spacing: 4.0){
                FontSettingToggleButton(setting: .bold, isOn: $settings.isBold)
                FontSettingToggleButton(setting: .italic, isOn: $settings.isItalic)
                FontSettingToggleButton(setting: .underline, isOn: $settings.isUnderline)
                FontSettingToggleButton(setting: .strikethrough, isOn: $settings.isStrikethrough)
                FontSettingToggleButton(setting: .shadow, isOn: $settings.isShadow)
            }
            .cornerRadius(10)
            
            VStack {
                Slider(value: $settings.fontSize, in: 8...16, step: 1)
                HStack {
                    Text("Font size")
                    Spacer()
                    Text("\(settings.fontSize, specifier: "%.0f")")
                }
            }
            
            ColorPicker("Text Color", selection: $settings.textColor, supportsOpacity: false)
            
        .padding()
        }
    }
}

struct FontView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FontFromatView()
                .previewLayout(.sizeThatFits)
            FontFromatView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
        .environmentObject(EditorSettingsViewModel())
    }
}

struct FontSettingToggleButton: View {
    let setting: FontFormatSetting
    @Binding var isOn: Bool
    
    var body: some View {
        Button {
            self.isOn.toggle()
        } label: {
            VStack{
                Image(systemName: setting.systemIconName)
                    .font(.system(size: 25))
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .padding()
                    .foregroundColor( Color.primary)
//                    .foregroundColor(isOn ? .green : Color(UIColor.secondaryLabel))
                    .background(isOn ? Color.accentColor : Color(UIColor.secondarySystemFill))
                    .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
