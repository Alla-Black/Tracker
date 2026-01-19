import UIKit
import CoreData

// MARK: - TrackerStoreProtocol

protocol TrackerStoreProtocol {
    var context: NSManagedObjectContext { get }
    func add(_ tracker: Tracker, categoryTitle: String) throws
    func delete(_ trackerCoreData: TrackerCoreData) throws
    func makeTracker(from object: TrackerCoreData) -> Tracker
}

// MARK: - TrackerStore

final class TrackerStore: TrackerStoreProtocol {
    
    // MARK: - Public Properties
    
    let context: NSManagedObjectContext
    
    // MARK: - Initializers
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    func add(_ tracker: Tracker, categoryTitle: String) throws {
        let object = TrackerCoreData(context: context)
        
        object.id = tracker.id
        object.name = tracker.name
        object.emoji = tracker.emoji
        object.color = tracker.color
        object.schedule = tracker.schedule as NSObject
        
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "title == %@", categoryTitle)
        request.fetchLimit = 1
        
        let fetchedCategories = try context.fetch(request)
       
        let category: TrackerCategoryCoreData
        if let existingCategory = fetchedCategories.first {
            category = existingCategory
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = categoryTitle
            category = newCategory
        }
        
        object.category = category
        try context.save()
    }
    
    func delete(_ trackerCoreData: TrackerCoreData) throws {
        context.delete(trackerCoreData)
        try context.save()
        
        NotificationCenter.default.post(name: .trackerRecordsDidChange, object: nil)
    }
    
    func makeTracker(from object: TrackerCoreData) -> Tracker {
        let id = object.id ?? UUID()
        let name = object.name ?? ""
        let emoji = object.emoji ?? ""
        let color = object.color as? UIColor ?? .black
        let schedule = object.schedule as? [Weekday] ?? []
        
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule
            )
    }
    
}

