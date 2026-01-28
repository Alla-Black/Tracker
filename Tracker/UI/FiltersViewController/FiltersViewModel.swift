import Foundation

final class FiltersViewModel {
    
    // MARK: - Public Properties
    
    var onFiltersChanged: (() -> Void)?
    var onFilterSelected: ((TrackersFilter) -> Void)?
    
    // MARK: - Private Properties
    
    private(set) var selectedFilter: TrackersFilter
    private let filters: [TrackersFilter] = TrackersFilter.allCases
    
    // MARK: - Initializers
    
    init(selectedFilter: TrackersFilter) {
        self.selectedFilter = selectedFilter
    }
    
    // MARK: - Lifecycle
    
    func viewDidLoad() {
        onFiltersChanged?()
    }
    
    // MARK: - Public Methods
    
    func numberOfRows() -> Int {
        filters.count
    }
    
    func filter(at index: Int) -> TrackersFilter {
        filters[index]
    }
    
    func shouldShowCheckmark(for filter: TrackersFilter) -> Bool {
        filter == selectedFilter && filter.showsCheckmarkInList
    }
    
    func didSelectRow(at index: Int) {
        let picked = filters[index]
        selectedFilter = picked
        onFilterSelected?(picked)
    }
}
