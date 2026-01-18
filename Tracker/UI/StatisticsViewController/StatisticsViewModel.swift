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

    // MARK: - Initializers
    
    init(statisticsProvider: StatisticsProviderProtocol) {
        self.statisticsProvider = statisticsProvider
    }

    // MARK: - Public Methods
    
    func viewDidLoad() {
        reload()
    }
    
    func reload() {
        let completed = statisticsProvider.completedCount()
        if completed == 0 {
            items = []
        } else {
            items = [StatisticsItem(value: completed, title: "Трекеров завершено")]
        }
    }
    
    func numberOfItems() -> Int {
        items.count
    }
    
    func item(at index: Int) -> StatisticsItem {
        items[index]
    }
}
