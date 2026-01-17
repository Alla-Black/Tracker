import Foundation

enum TrackersFilter: Int, CaseIterable {
    case all
    case today
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        case .all: return "Все трекеры"
        case .today: return "Трекеры на сегодня"
        case .completed: return "Завершенные"
        case .uncompleted: return "Не завершенные"
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
