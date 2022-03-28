//
//  NSAttributedString.swift
//  MNotes
//
//  Created by Sergey Petrov on 28.03.2022.
//

import Foundation

extension NSAttributedString {
    func getAttributes() -> [(NSRange, [NSAttributedString.Key: Any] )] {
        var attributesOverRanges : [(NSRange, [NSAttributedString.Key: Any])] = []
        var rng = NSRange()
        var idx = 0

        while idx < self.length {
            let foo = self.attributes(at: idx, effectiveRange: &rng)
            attributesOverRanges.append((rng, foo))

            idx = max(idx + 1, Range.init(rng)?.endIndex ?? 0)
        }
        return attributesOverRanges
    }
}

/* find the range of (the first occurence of) a given
   attribute 'attrName' for a given value 'forValue'. */
//extension NSAttributedString {
//
//    func findRangeOfAttribute(attrName: String, forValue value: AnyObject) -> NSRange? {
//
//        var rng = NSRange()
//
//        /* Is attribute (with given value) in range 0...X ? */
//        if let val = self.attribute(attrName, atIndex: 0, effectiveRange: &rng) where val.isEqual(value) { return rng }
//
//        /* If not, is attribute (with given value) anywhere in range X+1..<end? */
//        else if
//            let from = rng.toRange()?.endIndex where from < self.length - 1,
//            let val = self.attribute(attrName, atIndex: from, effectiveRange: &rng) where val.isEqual(value) { return rng }
//
//        /* if none of the above, return nil */
//        return nil
//    }
//}
