import UIKit

// MARK: - ScheduleTableView

final class ScheduleTableView: NSObject {
    
    // MARK: - Private Properties
    
    private let weekdays = Weekday.allCases
    private weak var tableView: UITableView?
    private var selectedWeekdays = Set<Weekday>()
    
    // MARK: - Initializers
    
    init(tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
}
    
// MARK: - UITableViewDataSource

extension ScheduleTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weekdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier, for: indexPath) as? ScheduleCell else { return UITableViewCell() }
        
        let day = weekdays[indexPath.row]
        let title = day.title
        let isOn = selectedWeekdays.contains(day)
        cell.configure(with: title, isOn: isOn)
        
        let isLastRow = indexPath.row == weekdays.count - 1
        cell.setSeparatorVisible(!isLastRow)
        
        cell.onSwitchChanged = { [weak self] isOn in
            guard let self else { return }
            
            if isOn {
                self.selectedWeekdays.insert(day)
            } else {
                self.selectedWeekdays.remove(day)
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ScheduleTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 75
    }
}
