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
    
    // MARK: - Private Methods
    
    private func recalc() {
        let query = normalizedQuery(from: searchText)
        let byDate = filterCategoriesByDate(allCategories, date: selectedDate)
        let result = filterCategoriesBySearchText(byDate, query: query)
        
        visibleCategories = result
        emptyState = makeEmptyState(query: query, visibleCategories: result)
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
    
    private func makeEmptyState(query: String, visibleCategories: [TrackerCategory]) -> EmptyState {
        if !query.isEmpty && visibleCategories.isEmpty {
            return .noResults
        }
        if visibleCategories.isEmpty {
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
