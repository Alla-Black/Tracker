import UIKit

// MARK: - ClearButtonInsetTextField

final class ClearButtonInsetTextField: UITextField {
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.x = bounds.width - rect.width - 12
        return rect
    }
}
