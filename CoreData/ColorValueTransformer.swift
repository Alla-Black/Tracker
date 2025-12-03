import UIKit

@objc
final class ColorValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass { NSData.self }
    
    override class func allowsReverseTransformation() -> Bool { true }
    
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
    
    static func register() {
        ValueTransformer.setValueTransformer(
            ColorValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: ColorValueTransformer.self))
        )
    }
}
