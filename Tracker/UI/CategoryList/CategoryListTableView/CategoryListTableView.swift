import UIKit

final class CategoryListTableView: NSObject {
    
    // MARK: - Private Properties
    
    private weak var tableView: UITableView?
    private let viewModel: CategoryListViewModel
    
    // MARK: - Initializers
    
    init(tableView: UITableView, viewModel: CategoryListViewModel) {
        self.viewModel = viewModel
        self.tableView = tableView
        
        super.init()
        
        tableView.register(CategoryListCell.self, forCellReuseIdentifier: CategoryListCell.reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
}

// MARK: - UITableViewDataSource

extension CategoryListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListCell.reuseIdentifier, for: indexPath) as? CategoryListCell else { return UITableViewCell() }
        
        let index = indexPath.row
        let title = viewModel.categoryTitle(at: index)
        cell.configure(with: title)
        
        let isLastRow = indexPath.row == viewModel.numberOfCategories() - 1 // текущая строка — последняя?
        cell.setSeparatorVisible(!isLastRow)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
}
