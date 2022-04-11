//
//  ScaledButtonStyle.swift
//  MNotes
//
//  Created by Sergey Petrov on 06.04.2022.
//

import SwiftUI

struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .shadow(color: configuration.isPressed ? Color.theme.buttonColor : Color.clear, radius: 20, x: 0, y: 0)
//            .scaleEffect(configuration.isPressed ?  0.9 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
//            .shadow(color: Color.theme.buttonColor, radius: 10, x: 5, y: 5)
//            .shadow(color: Color.theme.buttonColor, radius: 10, x: -5, y: -5)
    }
}
