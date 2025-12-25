import CoreData

// MARK: - TrackerCategoryStoreProtocol

protocol TrackerCategoryStoreProtocol {
    func addCategory(title: String) throws
    func delete(_ trackerCategoryCoreData: TrackerCategoryCoreData) throws
    func fetchCategoryTitles() -> [String]
}

// MARK: - TrackerCategoryStore

final class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    
    // MARK: - Initializers
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    func addCategory(title: String) throws {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        let object = TrackerCategoryCoreData(context: context)
        
        object.title = trimmedTitle
        
        try context.save()
    }
    
    func delete(_ trackerCategoryCoreData: TrackerCategoryCoreData) throws {
        context.delete(trackerCategoryCoreData)
        try context.save()
    }
    
    func fetchCategoryTitles() -> [String] {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            let objects = try context.fetch(request)
            return objects.compactMap { $0.title }
        } catch {
            return []
        }
    }
}
