import Foundation

final class StatisticsViewModel {

    // MARK: - Public Properties
    
    var isEmptyBinding: Binding<Bool>?
    var onStatsChanged: Binding<[StatisticsItem]>?

    // MARK: - Private Properties
    
    private let statisticsProvider: StatisticsProviderProtocol

    private var items: [StatisticsItem] = [] {
        didSet {
            if items.isEmpty {
                isEmptyBinding?(true)
            } else {
                isEmptyBinding?(false)
            }
            onStatsChanged?(items)
        }
    }
    
    private var recordsObserver: NSObjectProtocol?

    // MARK: - Initializers
    
    init(statisticsProvider: StatisticsProviderProtocol) {
        self.statisticsProvider = statisticsProvider
    }

    // MARK: - Public Methods
    
    func viewDidLoad() {
        setupObservers()
        reload()
    }
    
    func reload() {
        let completed = statisticsProvider.completedCount()
        items = completed == 0 ? [] : [StatisticsItem(value: completed, title: "Трекеров завершено")]
    }
    
    private func setupObservers() {
        recordsObserver = NotificationCenter.default.addObserver(
            forName: .trackerRecordsDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.reload()
        }
    }
    
    func numberOfItems() -> Int {
        items.count
    }
    
    func item(at index: Int) -> StatisticsItem {
        items[index]
    }
    
    deinit {
        if let recordsObserver {
            NotificationCenter.default.removeObserver(recordsObserver)
        }
    }
}
