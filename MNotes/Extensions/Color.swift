//
//  Color.swift
//  LoLInfo
//
//  Created by Sergey Petrov on 08.11.2021.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background =  Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)) //Color(UIColor.secondarySystemBackground)
    let noteColor = Color(UIColor.systemGray5)
    let buttonColor = Color(UIColor.systemIndigo)
}
