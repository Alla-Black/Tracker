import UIKit

final class FiltersTableView: NSObject {
    
    // MARK: - Private Properties
    
    private let tableView: UITableView
    private let viewModel: FiltersViewModel
    
    // MARK: - Initializers
    
    init(tableView: UITableView, viewModel: FiltersViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        
        configureTable()
    }
    
    // MARK: - Private Methods
    
    private func configureTable() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(FiltersListCell.self, forCellReuseIdentifier: FiltersListCell.reuseIdentifier)
        
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
    }
}

// MARK: - UITableViewDataSource

extension FiltersTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FiltersListCell.reuseIdentifier,
            for: indexPath
        ) as? FiltersListCell else {
            return UITableViewCell()
        }
        
        let filter = viewModel.filter(at: indexPath.row)
        cell.configure(title: filter.title)
        
        let isLast = indexPath.row == viewModel.numberOfRows() - 1
        cell.setSeparatorVisible(!isLast)
        
        cell.setCheckmarkVisible(viewModel.shouldShowCheckmark(for: filter))
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FiltersTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath.row)
        
    }
}

