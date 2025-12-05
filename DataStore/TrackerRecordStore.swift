import UIKit
import CoreData

// MARK: - TrackerRecordStoreProtocol

protocol TrackerRecordStoreProtocol {
    func add(_ record: TrackerRecord) throws
    func deleteRecord(trackerId: UUID, date: Date) throws
    func makeRecord(from object: TrackerRecordCoreData) -> TrackerRecord
}

// MARK: - TrackerRecordStore

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    
    // MARK: - Initializers
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    func add(_ record: TrackerRecord) throws {
        let trackerRequest = TrackerCoreData.fetchRequest()
        trackerRequest.predicate = NSPredicate(
            format: "id == %@",
            record.trackerId as CVarArg
        )
        
        let trackers = try context.fetch(trackerRequest)
        
        guard let trackerObject = trackers.first else {
            preconditionFailure("TrackerRecordStore error: tracker with id \(record.trackerId) not found")
        }
        
        let recordObject = TrackerRecordCoreData(context: context)
        recordObject.date = record.date
        recordObject.tracker = trackerObject
        
        try context.save()
        
    }
    
    func deleteRecord(trackerId: UUID, date: Date) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@ AND %K == %@",
            "tracker.id", trackerId as CVarArg,
            #keyPath(TrackerRecordCoreData.date), date as CVarArg
        )
        
        let objects = try context.fetch(request)
        objects.forEach { context.delete($0) }
        
        if !objects.isEmpty {
            try context.save()
        }
    }
    
    func makeRecord(from object: TrackerRecordCoreData) -> TrackerRecord {
        guard
            let trackerId = object.tracker?.id,
            let date = object.date
        else {
            preconditionFailure("TrackerRecordStore error: invalid TrackerRecordCoreData (trackerId/date)")
        }
        
        return TrackerRecord(
            trackerId: trackerId,
            date: date
        )
    }
    
}
