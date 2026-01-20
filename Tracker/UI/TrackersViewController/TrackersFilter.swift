import Foundation

enum TrackersFilter: Int, CaseIterable {
    case all
    case today
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        case .all: return AppStrings.Filters.all
        case .today: return AppStrings.Filters.today
        case .completed: return AppStrings.Filters.completed
        case .uncompleted: return AppStrings.Filters.incomplete
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
