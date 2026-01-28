import Foundation

enum TrackersFilter: Int, CaseIterable {
    case all
    case today
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        case .all: AppStrings.Filters.all
        case .today: AppStrings.Filters.today
        case .completed: AppStrings.Filters.completed
        case .uncompleted: AppStrings.Filters.incomplete
        }
    }
    
    var showsCheckmarkInList: Bool {
        switch self {
        case .completed, .uncompleted: return true
        case .all, .today: return false
        }
    }
    
    var isActiveFilter: Bool {
        switch self {
        case .completed, .uncompleted: return true
        case .all, .today: return false
        }
    }
}
