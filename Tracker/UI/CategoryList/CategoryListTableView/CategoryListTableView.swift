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
        
        configureTableView()
    }
    
    // MARK: - Private Methods

    private func configureTableView() {
        guard let tableView = tableView else { return }

        registerCells(in: tableView)
        setupAppearance(for: tableView)
        setupDelegates(for: tableView)
    }

    private func registerCells(in tableView: UITableView) {
        tableView.register(
            CategoryListCell.self,
            forCellReuseIdentifier: CategoryListCell.reuseIdentifier
        )
    }

    private func setupDelegates(for tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupAppearance(for tableView: UITableView) {
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
        let isSelected = viewModel.isSelectedCategory(at: index)
        
        cell.setSeparatorVisible(!isLastRow)
        cell.setSelectedState(isSelected)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        viewModel.selectCategory(at: selectedIndex)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
