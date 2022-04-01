//
//  UIImage.swift
//  MNotes
//
//  Created by Sergey Petrov on 31.03.2022.
//

import SwiftUI

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let height = CGFloat(ceil(width / size.width * size.height))
        let canvasSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


extension UIImage {
       // image with rounded corners
       public func withRoundedCorners(toWidth width: CGFloat, radius: CGFloat? = nil) -> UIImage? {
           
           let height = CGFloat(ceil(width / size.width * size.height))
           let canvasSize = CGSize(width: width, height: height)
           
           let maxRadius = min(size.width, size.height) / 2
           let cornerRadius: CGFloat
           if let radius = radius, radius > 0 && radius <= maxRadius {
               cornerRadius = radius
           } else {
               cornerRadius = maxRadius
           }
           UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
           let rect = CGRect(origin: .zero, size: canvasSize)
           UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
           draw(in: rect)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image
       }
   }
