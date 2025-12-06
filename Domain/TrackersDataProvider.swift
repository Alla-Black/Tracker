import UIKit
import CoreData

// MARK: - TrackersStoreUpdate

struct TrackersStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
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
    
    func add(_ tracker: Tracker) throws
    func delete(at indexPath: IndexPath) throws
    
    func isTrackerCompleted(_ tracker: Tracker, on date: Date) -> Bool
    func toggleRecord(for tracker: Tracker, on date: Date) throws
    func getAllCategories() -> [TrackerCategory]
}

// MARK: - TrackersDataProvider

final class TrackersDataProvider: NSObject {
    
    // MARK: - Public Properties
    
    var context: NSManagedObjectContext
    
    // MARK: - Private Properties
    
    private let trackerStore: TrackerStoreProtocol
    private let recordStore: TrackerRecordStoreProtocol
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    
    private weak var delegate: TrackersDataProviderDelegate?
    
    // MARK: - FetchedResultsController
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
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
        let objects = fetchedResultsController.fetchedObjects ?? []
        let trackers = objects.compactMap { trackerStore.makeTracker(from: $0) }
        
        guard !trackers.isEmpty else { return [] }
        
        return [TrackerCategory(title: "Важное", trackers: trackers)]
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
    
    func add(_ tracker: Tracker) throws {
        try trackerStore.add(tracker)
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
}

// MARK: - NSFetchedResultsControllerDelegate Extension

extension TrackersDataProvider: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
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
                insertedIndexes?.insert(newIndexPath.item)
            }
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        guard
            let inserted = insertedIndexes,
            let deleted = deletedIndexes
        else {
            insertedIndexes = nil
            deletedIndexes = nil
            return
        }
        
        let update = TrackersStoreUpdate(
            insertedIndexes: inserted,
            deletedIndexes: deleted
        )
        delegate?.didUpdate(update)
        
        insertedIndexes = nil
        deletedIndexes = nil
    }
}
