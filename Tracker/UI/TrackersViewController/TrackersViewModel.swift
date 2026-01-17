import Foundation

final class TrackersViewModel {
    enum EmptyState {
        case none
        case emptyList
        case noResults
    }
    
    // MARK: - Public Properties
    
    var onVisibleCategoriesChanged: (([TrackerCategory]) -> Void)?
    var onEmptyStateChanged: ((EmptyState) -> Void)?
    var onFilterChanged: ((TrackersFilter) -> Void)?
    
    var currentFilter: TrackersFilter { selectedFilter }
    var currentDate: Date { selectedDate }
    
    // MARK: - Private Properties
    
    private(set) var visibleCategories: [TrackerCategory] = [] {
        didSet { onVisibleCategoriesChanged?(visibleCategories) }
    }
    private(set) var emptyState: EmptyState = .none {
        didSet { onEmptyStateChanged?(emptyState) }
    }
    
    private var allCategories: [TrackerCategory] = []
    private var selectedDate: Date = Date()
    private var searchText: String = ""
    private var selectedFilter: TrackersFilter = .all
    private var completedIDs: Set<UUID> = []
    
    // MARK: - Public Methods
    
    func setCategories(_ categories: [TrackerCategory]) {
        allCategories = categories
        recalc()
    }
    
    func setSelectedDate(_ date: Date) {
        selectedDate = date
        recalc()
    }
    
    func setSearchText(_ text: String) {
        searchText = text
        recalc()
    }
    
    func setFilter(_ filter: TrackersFilter) {
        selectedFilter = filter
        onFilterChanged?(filter)
        
        if filter == .today {
            setSelectedDate(Date())
            return
        }
        
        recalc()
    }
    
    func setCompletedTrackerIDs(_ ids: Set<UUID>) {
        completedIDs = ids
        recalc()
    }
    
    // MARK: - Private Methods
    
    private func recalc() {
        let query = normalizedQuery(from: searchText)
        
        let byDate = filterCategoriesByDate(allCategories, date: selectedDate)
        let byFilter = filterCategoriesByCompletion(byDate, filter: selectedFilter, completedIDs: completedIDs)
        let result = filterCategoriesBySearchText(byFilter, query: query)
        
        visibleCategories = result
        emptyState = makeEmptyState(
            query: query,
            baseByDate: byDate,
            visibleCategories: result,
            filter: selectedFilter
        )
    }
    
    private func filterCategoriesByDate(_ categories: [TrackerCategory], date: Date) -> [TrackerCategory] {
        guard let weekday = Weekday.from(date: date) else { return [] }
        
        return categories
            .map { category in
                let trackersForDay = category.trackers.filter { tracker in
                    tracker.schedule.contains(weekday)
                }
                return TrackerCategory(title: category.title, trackers: trackersForDay)
            }
            .filter { !$0.trackers.isEmpty }
    }
    
    private func filterCategoriesByCompletion(
        _ categories: [TrackerCategory],
        filter: TrackersFilter,
        completedIDs: Set<UUID>
    ) -> [TrackerCategory] {
        switch filter {
        case .all, .today:
            return categories
            
        case .completed:
            return categories
                .map { category in
                    let trackers = category.trackers.filter { completedIDs.contains($0.id) }
                    return TrackerCategory(title: category.title, trackers: trackers)
                }
                .filter { !$0.trackers.isEmpty }
            
        case .uncompleted:
            return categories
                .map { category in
                    let trackers = category.trackers.filter { !completedIDs.contains($0.id) }
                    return TrackerCategory(title: category.title, trackers: trackers)
                }
                .filter { !$0.trackers.isEmpty }
        }
    }
    
    private func filterCategoriesBySearchText(_ categories: [TrackerCategory], query: String) -> [TrackerCategory] {
        guard !query.isEmpty else { return categories }
        
        return categories
            .map { category in
                let filteredTrackers = category.trackers.filter { tracker in
                    tracker.name.lowercased().contains(query)
                }
                return TrackerCategory(title: category.title, trackers: filteredTrackers)
            }
            .filter { !$0.trackers.isEmpty }
    }
    
    private func makeEmptyState(
        query: String,
        baseByDate: [TrackerCategory],
        visibleCategories: [TrackerCategory],
        filter: TrackersFilter
    ) -> EmptyState {
        if baseByDate.isEmpty {
            return .emptyList
        }
        
        if visibleCategories.isEmpty {
            if !query.isEmpty || filter.isActiveFilter {
                return .noResults
            }
            return .emptyList
        }
        
        return .none
    }
    
    private func normalizedQuery(from text: String) -> String {
        text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
    
}
