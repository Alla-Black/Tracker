import UIKit

// MARK: - TrackerSettingsTableView

final class TrackerSettingsTableView: NSObject {
    
    // MARK: - Public Properties
    
    var onSelectRow: ((Int) -> Void)?
    
    // MARK: - Private Properties
    
    private let items = ["Категория", "Расписание"]
    private weak var tableView: UITableView?
    
    private var categorySubtitle: String?
    private var scheduleSubtitle: String?
    
    // MARK: - Initializers
    
    init(tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        
        tableView.register(TrackerSettingsCell.self, forCellReuseIdentifier: TrackerSettingsCell.reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    // MARK: - Public Methods
    
    func updateCategorySubtitle(_ text: String?) {
        categorySubtitle = text
        reloadRow(at: 0)
    }

    func updateScheduleSubtitle(_ text: String?) {
        scheduleSubtitle = text
        reloadRow(at: 1)
    }
    
    // MARK: - Private Methods
    
    private func reloadRow(at row: Int) {
        guard let tableView = tableView else { return }
        
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
    
// MARK: - UITableViewDataSource

extension TrackerSettingsTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerSettingsCell.reuseIdentifier, for: indexPath) as? TrackerSettingsCell else { return UITableViewCell() }
        
        let title = items[indexPath.row]
        cell.configure(with: title)
        
        switch indexPath.row {
        case 0:
            cell.setSubtitle(categorySubtitle)
        case 1:
            cell.setSubtitle(scheduleSubtitle)
        default:
            cell.setSubtitle(nil)
        }
        
        let isLastRow = indexPath.row == items.count - 1
        cell.setSeparatorVisible(!isLastRow)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TrackerSettingsTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        onSelectRow?(indexPath.row)
    }
}
