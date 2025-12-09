import Foundation

// MARK: - WeekdayValueTransformer

@objc
final class WeekdayValueTransformer: ValueTransformer {
    
    // MARK: - ValueTransformer Overrides
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    
    override class func allowsReverseTransformation() -> Bool { true }
    
    // MARK: - Forward Transform (Weekday → Data)
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let weekday = value as? [Weekday] else { return nil }
        return try? JSONEncoder().encode(weekday)
    }
    
    // MARK: - Reverse Transform (Data → Weekday)
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? JSONDecoder().decode([Weekday].self, from: data as Data)
    }
    
    // MARK: - Registration
    
    static func register() {
        ValueTransformer.setValueTransformer(
            WeekdayValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: WeekdayValueTransformer.self))
        )
    }
}
