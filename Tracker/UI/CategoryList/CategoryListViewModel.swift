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
    
    private let store: TrackerCategoryStoreProtocol
    
    // MARK: - Initializers
    
    init(trackerCategoryStore: TrackerCategoryStoreProtocol) {
        self.store = trackerCategoryStore
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        categories = store.fetchCategoryTitles()
    }
    
    func numberOfCategories() -> Int {
        categories.count
    }
    
    func categoryTitle(at index: Int) -> String {
        categories[index]
    }
    
    func addCategory(with title: String) {
        do {
            try store.addCategory(title: title)
            categories = store.fetchCategoryTitles()
        } catch {
            print(error)
        }
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
