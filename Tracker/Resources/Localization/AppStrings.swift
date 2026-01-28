import Foundation

enum AppStrings {
    
    enum MainTab {
        static let tabTrackersTitle = NSLocalizedString("mainTab.trackers.title", comment: "")
        static let tabStatisticsTitle = NSLocalizedString("mainTab.statistics.title", comment: "")
    }
    
    enum Trackers {
        static let navigationTitle = NSLocalizedString("trackers.nav.title", comment: "")
        static let emptyStateTitle = NSLocalizedString("trackers.emptyState.title", comment: "")
        static let filtersButtonTitle = NSLocalizedString("trackers.filters.button", comment: "")
        static let noResultsTitle = NSLocalizedString("trackers.noResults.title", comment: "")
        static let deleteAlertTitle = NSLocalizedString("trackers.deleteAlert.title", comment: "")
    }
    
    enum Filters {
        static let all = NSLocalizedString("trackers.filters.all", comment: "")
        static let today = NSLocalizedString("trackers.filters.today", comment: "")
        static let completed = NSLocalizedString("trackers.filters.completed", comment: "")
        static let incomplete = NSLocalizedString("trackers.filters.incomplete", comment: "")
    }
    
    enum Common {
        static let searchPlaceholder = NSLocalizedString("common.search.placeholder", comment: "")
        static let сancelButton = NSLocalizedString("common.cancel.button", comment: "")
        static let deleteButton = NSLocalizedString("common.delete.button", comment: "")
        static let editButton = NSLocalizedString("common.edit.button", comment: "")
    }
}
