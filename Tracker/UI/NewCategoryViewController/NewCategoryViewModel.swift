import Foundation

final class NewCategoryViewModel {
    // MARK: - Public Properties
    
    private(set) var categoryTitle: String = ""
    var onFormValidChanged: Binding<Bool>?
    
    // MARK: - Public Methods
    
    func updateCategoryTitle(with title: String?) {
        categoryTitle = title?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        let isValid = !categoryTitle.isEmpty
        
        onFormValidChanged?(isValid)
    }
    
}
