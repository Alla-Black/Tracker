import UIKit

final class StatisticsTableView: NSObject {

    // MARK: - Private Properties
    
    private weak var tableView: UITableView?
    private let viewModel: StatisticsViewModel

    // MARK: - Initializers
    
    init(tableView: UITableView, viewModel: StatisticsViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
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
        tableView.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.reuseIdentifier)
    }

    private func setupAppearance(for tableView: UITableView) {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    private func setupDelegates(for tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension StatisticsTableView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsCell.reuseIdentifier,
            for: indexPath
        ) as? StatisticsCell else {
            return UITableViewCell()
        }

        let item = viewModel.item(at: indexPath.section)
        cell.configure(with: item)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension StatisticsTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 0 : 12
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
