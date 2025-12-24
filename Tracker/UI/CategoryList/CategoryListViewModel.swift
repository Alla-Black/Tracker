import Foundation

final class CategoryListViewModel {
    // MARK: - Public Properties
    
    var isEmptyBinding: Binding<Bool>?
    var onCategoriesChanged: Binding<[String]>?
    var onCategorySelected: Binding<String>?
    
    // MARK: - Private Properties
    
    private var categories: [String] = [] {
        didSet {
           if categories.isEmpty {
                isEmptyBinding?(true)
           } else {
               isEmptyBinding?(false)
           }
            onCategoriesChanged?(categories)
        }
    }
    
    private var selectedCategoryIndex: Int?
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        categories = ["Дом", "Работа", "Привычки", "Спорт", "Самочувствие", "Животные", "Питание", "Сон", "Обучение"]
    }
    
    func numberOfCategories() -> Int {
        categories.count
    }
    
    func categoryTitle(at index: Int) -> String {
        categories[index]
    }
    
    func addCategory(with title: String) {
        categories.append(title)
    }
    
    func setSelectedCategory(with title: String?) {
        guard let title, !title.isEmpty else { return }
        guard let index = categories.firstIndex(of: title) else { return }
        
        selectedCategoryIndex = index
        onCategoriesChanged?(categories)
    }
    
    func selectCategory(at index: Int) {
        guard (0..<categories.count).contains(index) else {
            return
        }
        selectedCategoryIndex = index
        onCategoriesChanged?(categories)
        
        let title = categories[index]
        onCategorySelected?(title)
    }
    
    func isSelectedCategory(at index: Int) -> Bool {
        selectedCategoryIndex == index
    }
}
