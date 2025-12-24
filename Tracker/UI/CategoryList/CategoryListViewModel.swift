import Foundation

final class CategoryListViewModel {
    // MARK: - Public Properties
    
    var isEmptyBinding: Binding<Bool>?
    var onCategoriesChanged: Binding<[String]>?
    
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
}
