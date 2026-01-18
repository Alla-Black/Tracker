import Foundation

// MARK: - StatisticsProviderProtocol

protocol StatisticsProviderProtocol {
    func completedCount() -> Int
}

// MARK: - StatisticsProvider

final class StatisticsProvider: StatisticsProviderProtocol {
    
    // MARK: - Private Properties
    
    private let recordStore: TrackerRecordStoreProtocol
    
    // MARK: - Initializers
    
    init(recordStore: TrackerRecordStoreProtocol) {
        self.recordStore = recordStore
    }
    
    // MARK: - Public Methods
    
    func completedCount() -> Int {
        recordStore.totalRecordsCount()
    }
}
