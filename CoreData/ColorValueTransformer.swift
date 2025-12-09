import UIKit

// MARK: - ColorValueTransformer

@objc
final class ColorValueTransformer: ValueTransformer {
    
    // MARK: - ValueTransformer Overrides
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    
    override class func allowsReverseTransformation() -> Bool { true }
    
    // MARK: - Forward Transform (UIColor → Data)
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: color,
                requiringSecureCoding: true
            )
            return data
        } catch {
            assertionFailure("Failed to transform UIColor to Data: \(error)")
            return nil
        }
    }
    
    // MARK: - Reverse Transform (Data → UIColor)
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(
                ofClass: UIColor.self,
                from: data
            )
            return color
        } catch {
            assertionFailure("Failed to transform Data to UIColor: \(error)")
            return nil
        }
    }
    
    // MARK: - Registration
    
    static func register() {
        ValueTransformer.setValueTransformer(
            ColorValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: ColorValueTransformer.self))
        )
    }
}
