//
//   ValueTransformers.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 11.07.2025.
//

import UIKit

@objc(WeekDayValueTransformer)
final class WeekDayValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [WeekDay] else { return nil }
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([WeekDay].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            WeekDayValueTransformer(),
            forName: NSValueTransformerName(rawValue: "WeekDayValueTransformer"))
    }
}

@objc(UIColorValueTransformer)
final class UIColorValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }
        return try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            UIColorValueTransformer(),
            forName: NSValueTransformerName(rawValue: "UIColorValueTransformer"))
    }
}
