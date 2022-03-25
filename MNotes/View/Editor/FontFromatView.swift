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
            HStack {
                HStack(spacing: 4.0){
                    FontSettingToggleButton(setting: .bold, isOn: $settings.fontSettings.isBold)
                    FontSettingToggleButton(setting: .italic, isOn: $settings.fontSettings.isItalic)
                    FontSettingToggleButton(setting: .underline, isOn: $settings.fontSettings.isUnderline)
                    FontSettingToggleButton(setting: .strikethrough, isOn: $settings.fontSettings.isStrikethrough)
                    FontSettingToggleButton(setting: .shadow, isOn: $settings.fontSettings.isShadow)
                }
                .cornerRadius(10)
                ColorPicker("", selection: $settings.fontSettings.textColor, supportsOpacity: false)
                    .frame(width: 50, height: 50, alignment: .leading)
                    .clipped()
                    .scaleEffect(1.5)
            }
            
            HStack{
                Text("a  -")
                Slider(value: $settings.fontSettings.fontSize, in: 10...40, step: 1)
                Text("+ A")
                Text("\(settings.fontSettings.fontSize, specifier: "%.0f")")
                    .frame(width: 30, alignment: .trailing)
            }
            .padding()
            
        }
        .padding(.horizontal)
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
                    .frame(height: 25)
                    .padding()
                    .foregroundColor( Color.primary)
                    .background(isOn ? Color.accentColor : Color(UIColor.secondarySystemFill))
                    .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
