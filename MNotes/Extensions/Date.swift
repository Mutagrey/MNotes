//
//  Date.swift
//  MNotes
//
//  Created by Sergey Petrov on 16.03.2022.
//

import SwiftUI

extension Date {
    func dateToString(formatString: String = "d.MMM.y, EEEE HH:mm  ") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatString
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }
    
//    func modifiedDateToString(startDate: Date) -> String {
////                let curCalendar = Calendar.current
////                let isDaysEqual = curCalendar.dateComponents([Calendar.Component.day], from: startDate) == curCalendar.dateComponents([Calendar.Component.day], from: Date())
////
////                let dateFormatter = DateFormatter()
////                dateFormatter.dateStyle = isDaysEqual ? .none : .short
////
////        dateFormatter.dateFormat = "EEEE"
////                dateFormatter.timeStyle = .short
////                dateFormatter.locale = Locale(identifier: "ru_RU")
////
////                return dateFormatter.string(from: date)
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = formatString
//        formatter.locale = Locale(identifier: "ru_RU")
//        return formatter.string(from: self)
//    }
}

