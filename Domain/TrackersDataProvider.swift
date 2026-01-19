import UIKit
import CoreData

// MARK: - TrackersStoreUpdate

struct TrackersStoreUpdate {
    let insertedIndexPaths: [IndexPath]
    let deletedIndexPaths: [IndexPath]
}

// MARK: - TrackersDataProviderDelegate

protocol TrackersDataProviderDelegate: AnyObject {
    func didUpdate(_ update: TrackersStoreUpdate)
}

// MARK: - TrackersDataProviderProtocol

protocol TrackersDataProviderProtocol: AnyObject {
    var numberOfSections: Int { get }
    func numberOfItems(in section: Int) -> Int
    
    func tracker(at indexPath: IndexPath) -> Tracker
    
    func add(_ tracker: Tracker, categoryTitle: String) throws
    func delete(at indexPath: IndexPath) throws
    
    func isTrackerCompleted(_ tracker: Tracker, on date: Date) -> Bool
    func toggleRecord(for tracker: Tracker, on date: Date) throws
    func completedTrackerIDs(on date: Date) -> Set<UUID>
    func getAllCategories() -> [TrackerCategory]
    func completedCount(for tracker: Tracker) -> Int
    func update(_ tracker: Tracker, categoryTitle: String) throws
}

// MARK: - TrackersDataProvider

final class TrackersDataProvider: NSObject {
    
    // MARK: - Public Properties
    
    var context: NSManagedObjectContext
    
    // MARK: - Private Properties
    
    private let trackerStore: TrackerStoreProtocol
    private let recordStore: TrackerRecordStoreProtocol
    
    private var insertedIndexPaths: [IndexPath]?
    private var deletedIndexPaths: [IndexPath]?
    
    private weak var delegate: TrackersDataProviderDelegate?
    
    // MARK: - FetchedResultsController
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "category.title",
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }()
    
    // MARK: - Initializers
    
    init(
        trackerStore: TrackerStoreProtocol,
        recordStore: TrackerRecordStoreProtocol,
        delegate: TrackersDataProviderDelegate?
    ) {
        self.trackerStore = trackerStore
        self.recordStore = recordStore
        self.context = trackerStore.context
        self.delegate = delegate
        super.init()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("TrackersDataProvider: failed to perform fetch – \(error)")
        }
    }
    
    // MARK: - Public Methods
    
    func getAllCategories() -> [TrackerCategory] {
        let sections = fetchedResultsController.sections ?? []
        guard !sections.isEmpty else { return [] }
        
        return sections.map { section in
            let title = section.name
            
            let objects = section.objects as? [TrackerCoreData] ?? []
            let trackers = objects.map { trackerStore.makeTracker(from: $0) }
            
            return TrackerCategory(title: title, trackers: trackers)
        }
    }
}

// MARK: - TrackersDataProviderProtocol Extension

extension TrackersDataProvider: TrackersDataProviderProtocol {
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfItems(in section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker {
        let object = fetchedResultsController.object(at: indexPath)
        return trackerStore.makeTracker(from: object)
    }
    
    func add(_ tracker: Tracker, categoryTitle: String) throws {
        try trackerStore.add(tracker, categoryTitle: categoryTitle)
    }
    
    func delete(at indexPath: IndexPath) throws {
        let object = fetchedResultsController.object(at: indexPath)
        try trackerStore.delete(object)
    }
    
    func isTrackerCompleted(_ tracker: Tracker, on date: Date) -> Bool {
        recordStore.hasRecord(trackerId: tracker.id, date: date)
    }
    
    func toggleRecord(for tracker: Tracker, on date: Date) throws {
        if isTrackerCompleted(tracker, on: date) {
            try recordStore.deleteRecord(trackerId: tracker.id, date: date)
        } else {
            let record = TrackerRecord(trackerId: tracker.id, date: date)
            try recordStore.add(record)
        }
    }
    
    func completedTrackerIDs(on date: Date) -> Set<UUID> {
        recordStore.completedTrackerIDs(on: date)
    }
    
    func completedCount(for tracker: Tracker) -> Int {
        recordStore.completedCount(for: tracker.id)
    }
    
    func update(_ tracker: Tracker, categoryTitle: String) throws {
        try trackerStore.update(tracker, categoryTitle: categoryTitle)
    }
}

// MARK: - NSFetchedResultsControllerDelegate Extension

extension TrackersDataProvider: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        insertedIndexPaths = []
        deletedIndexPaths = []
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                insertedIndexPaths?.append(newIndexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                deletedIndexPaths?.append(indexPath)
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        guard
            let inserted = insertedIndexPaths,
            let deleted = deletedIndexPaths
        else {
            insertedIndexPaths = nil
            deletedIndexPaths = nil
            return
        }
        
        let update = TrackersStoreUpdate(
            insertedIndexPaths: inserted,
            deletedIndexPaths: deleted
        )
        delegate?.didUpdate(update)
        
        insertedIndexPaths = nil
        deletedIndexPaths = nil
    }
}
