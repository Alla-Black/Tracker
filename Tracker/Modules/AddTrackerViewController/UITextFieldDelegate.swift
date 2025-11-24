import UIKit

extension AddTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        let isTooLong = updatedText.count > characterLimit
        
        let trimmed = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
        let isEmpty = trimmed.isEmpty
        
        updateLimitLayout(isTooLong: isTooLong)
        
        isTitleValid = !isEmpty && !isTooLong
        updateCreateButtonState()
        
        return true
        
    }
}
