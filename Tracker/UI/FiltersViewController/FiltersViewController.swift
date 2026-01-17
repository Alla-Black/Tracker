import UIKit

final class FiltersViewController: UIViewController {
    // MARK: - Public Properties
    
    var onSelectFilter: ((TrackersFilter) -> Void)?
    
    // MARK: - Private Properties
    
    private let viewModel: FiltersViewModel
    
    private lazy var tableViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundYP
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var filtersTableView: FiltersTableView = {
        FiltersTableView(tableView: tableView, viewModel: viewModel)
    }()
    
    // MARK: - Initializers
    
    init(viewModel: FiltersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureAppearance()
        setupConstraints()
        
        bindViewModel()
        _ = filtersTableView
        viewModel.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.addSubviews([tableViewContainer])
        tableViewContainer.addSubview(tableView)
    }
    
    private func configureAppearance() {
        view.backgroundColor = .whiteYP
        
        // NavBar Title
        title = "Фильтры"
        if let navBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            appearance.backgroundColor = .whiteYP
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.blackYP,
                .font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ]
            
            appearance.shadowColor = .clear
            
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.compactAppearance = appearance
        }
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
    }
    
    private func setupConstraints() {
        [tableViewContainer, tableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            tableViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewContainer.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            tableViewContainer.heightAnchor.constraint(equalToConstant: 300),
            
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onFiltersChanged = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onFilterSelected = { [weak self] filter in
            guard let self else { return }
            self.onSelectFilter?(filter)
            self.dismiss(animated: true)
        }
    }
}
