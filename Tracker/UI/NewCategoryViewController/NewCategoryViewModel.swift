import Foundation

final class NewCategoryViewModel {
    // MARK: - Public Properties
    
    var onFormValidChanged: Binding<Bool>?
    var onCategoryCreated: Binding<String>?
    
    // MARK: - Private Properties
    
    private(set) var categoryTitle: String = ""
    
    // MARK: - Public Methods
    
    func updateCategoryTitle(with title: String?) {
        categoryTitle = title?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        let isValid = !categoryTitle.isEmpty
        
        onFormValidChanged?(isValid)
    }
    
    func doneButtonTapped() {
        guard !categoryTitle.isEmpty else { return }
            onCategoryCreated?(categoryTitle)
    }
}
