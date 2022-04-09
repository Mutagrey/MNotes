//
//  NeumorphicModifier.swift
//  MNotes
//
//  Created by Sergey Petrov on 03.04.2022.
//

import SwiftUI

struct NeumorphicModifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .background(
                ZStack{
//                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                    Rectangle()
                        .shadow(color: Color.white.opacity(0.7), radius: 8, x: -5, y: -5)
                        .shadow(color: Color.black.opacity(0.7), radius: 5, x: 5, y: 5)
                        .blendMode(.overlay)
//                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                    Rectangle()
                        .fill(color)
                }
            )
//            .scaleEffect(self.isPressed ? 0.98: 1)
//            .foregroundColor(.primary)
//            .animation(.spring())
    }
}


extension View {
    
    func neumorphicShadows(color: Color = Color.theme.background ) -> some View {
        self
            .modifier(NeumorphicModifier(color: color))
    }
}
