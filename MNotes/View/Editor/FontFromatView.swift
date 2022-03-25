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
                FontSettingToggleButton(setting: .bold, isOn: $settings.fontSettings.isBold)
                FontSettingToggleButton(setting: .italic, isOn: $settings.fontSettings.isItalic)
                FontSettingToggleButton(setting: .underline, isOn: $settings.fontSettings.isUnderline)
                FontSettingToggleButton(setting: .strikethrough, isOn: $settings.fontSettings.isStrikethrough)
                FontSettingToggleButton(setting: .shadow, isOn: $settings.fontSettings.isShadow)
            }
            .cornerRadius(10)
            
            HStack{
                Text("a  -")
                Slider(value: $settings.fontSettings.fontSize, in: 10...25, step: 1)
                Text("+ A")
                Text("\(settings.fontSettings.fontSize, specifier: "%.0f")")
                    .frame(width: 30, alignment: .trailing)
                ColorPicker("Text Color", selection: $settings.fontSettings.textColor, supportsOpacity: false)
                    .frame(width: 35, height: 40, alignment: .leading)
                    .cornerRadius(20)
            }
            .padding(.horizontal)
            
            
            
        
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
