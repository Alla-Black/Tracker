import UIKit

final class StatisticsViewController: UIViewController {

    // MARK: - Private Properties
    
    private let viewModel: StatisticsViewModel
    private var tableManager: StatisticsTableView?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.textColor = UIColor(resource: .blackYP)
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var stubImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(resource: .statisticStub)
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.textColor = UIColor(resource: .blackYP)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private lazy var stubStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stubImageView, stubLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.isHidden = true
        return stack
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()

    // MARK: - Initializers
    
    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableManager()
        bindViewModel()
        viewModel.viewDidLoad()
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .whiteYP

        view.addSubviews([titleLabel, tableView, stubStack])
    }

    private func setupConstraints() {
        [titleLabel, tableView, stubStack, stubImageView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            
            stubStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableManager() {
        tableManager = StatisticsTableView(tableView: tableView, viewModel: viewModel)
    }
    
    private func bindViewModel() {
        viewModel.isEmptyBinding = { [weak self] isEmpty in
            guard let self else { return }
            self.stubStack.isHidden = !isEmpty
            self.tableView.isHidden = isEmpty
        }
        
        viewModel.onStatsChanged = { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}
