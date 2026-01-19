import Foundation
import CoreData

// MARK: - TrackerRecordStoreProtocol

protocol TrackerRecordStoreProtocol {
    func add(_ record: TrackerRecord) throws
    func deleteRecord(trackerId: UUID, date: Date) throws
    func hasRecord(trackerId: UUID, date: Date) -> Bool
    func makeRecord(from object: TrackerRecordCoreData) -> TrackerRecord
    func completedCount(for trackerId: UUID) -> Int
    func completedTrackerIDs(on date: Date) -> Set<UUID>
    func totalRecordsCount() -> Int
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
        recordObject.date = normalizedDate(record.date)
        recordObject.tracker = trackerObject
        
        try context.save()
        NotificationCenter.default.post(name: .trackerRecordsDidChange, object: nil)
        
    }
    
    func deleteRecord(trackerId: UUID, date: Date) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return
        }
        
        request.predicate = NSPredicate(
            format: "tracker.id == %@ AND date >= %@ AND date < %@",
            trackerId as CVarArg,
            startOfDay as CVarArg,
            endOfDay as CVarArg
        )
        
        let objects = try context.fetch(request)
        objects.forEach { context.delete($0) }
        
        if !objects.isEmpty {
            try context.save()
            NotificationCenter.default.post(name: .trackerRecordsDidChange, object: nil)
        }
    }
    
    func hasRecord(trackerId: UUID, date: Date) -> Bool {
        let request = TrackerRecordCoreData.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return false
        }
        
        request.predicate = NSPredicate(
            format: "tracker.id == %@ AND date >= %@ AND date < %@",
            trackerId as CVarArg,
            startOfDay as CVarArg,
            endOfDay as CVarArg
        )
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            assertionFailure("TrackerRecordStore error: failed to check record existence: \(error)")
            return false
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
    
    func completedCount(for trackerId: UUID) -> Int {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "tracker.id == %@",
            trackerId as CVarArg
        )
        
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            assertionFailure("TrackerRecordStore error: failed to get completed count: \(error)")
            return 0
        }
    }
    
    func completedTrackerIDs(on date: Date) -> Set<UUID> {
        let request = TrackerRecordCoreData.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return []
        }
        
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            startOfDay as CVarArg,
            endOfDay as CVarArg
        )
        
        do {
            let records = try context.fetch(request)
            let ids = records.compactMap { $0.tracker?.id }
            return Set(ids)
        } catch {
            assertionFailure("TrackerRecordStore: failed to fetch completed tracker ids: \(error)")
            return []
        }
    }
    
    func totalRecordsCount() -> Int {
        let request = TrackerRecordCoreData.fetchRequest()
        
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            assertionFailure("TrackerRecordStore error: failed to get total records count: \(error)")
            return 0
        }
    }
    
    // MARK: - Private Methods
    
    private func normalizedDate(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }
    
}
