import UIKit

final class CategoryListViewController: UIViewController {
    // MARK: - Private Properties
    
    private lazy var stubImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .trackersPlaceholder)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно \n объединить по смыслу"
        label.textColor = UIColor(resource: .blackYP)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private lazy var stubStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackYP
        button.layer.cornerRadius = 16
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.whiteYP, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(
            self,
            action: #selector(addCategoryButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var tableViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundYP
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    private lazy var categoryListTableView: CategoryListTableView = {
        CategoryListTableView(tableView: tableView, viewModel: viewModel)
    }()
    
    private let viewModel = CategoryListViewModel()
    
    private var tableContainerHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureAppearance()
        setupConstraints()
        view.layoutIfNeeded()
    
        bindViewModel()
        _ = categoryListTableView
        viewModel.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.addSubviews([tableViewContainer, stubStack, addCategoryButton])
        stubStack.addArrangedSubview(stubImage)
        stubStack.addArrangedSubview(stubLabel)
        tableViewContainer.addSubview(tableView)
    }
    
    private func configureAppearance() {
        view.backgroundColor = .whiteYP
        
        // NavBar Title
        title = "Категория"
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
        [tableViewContainer, tableView, stubStack, stubImage, stubLabel, addCategoryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let heightConstraint =
                tableViewContainer.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.priority = .defaultHigh
        tableContainerHeightConstraint = heightConstraint
        
        NSLayoutConstraint.activate([
            tableViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewContainer.bottomAnchor.constraint(lessThanOrEqualTo: addCategoryButton.topAnchor, constant: -114),
            
            heightConstraint,
            
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            
            stubStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stubStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setStub(isEmpty: Bool) {
        stubStack.isHidden = !isEmpty
        tableViewContainer.isHidden = isEmpty
    }
    
    private func bindViewModel() {
        viewModel.isEmptyBinding = { [weak self] isEmpty in
            self?.setStub(isEmpty: isEmpty)
        }
        
        viewModel.onCategoriesChanged = { [weak self] _ in
            guard let self else { return }
            
            self.tableView.reloadData()
            
            self.tableView.layoutIfNeeded()
            self.view.layoutIfNeeded()
            
            let rows = self.viewModel.numberOfCategories()
            let rowHeight: CGFloat = 75
            let contentHeight = CGFloat(rows) * rowHeight

            let maxHeight = (self.addCategoryButton.frame.minY - 114) - (self.view.safeAreaInsets.top + 24)
            let newHeight = max(0, min(contentHeight, maxHeight))
            
            self.tableContainerHeightConstraint?.constant = newHeight
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func addCategoryButtonTapped() {
        openNewCategoryScreen()
    }
    
    private func openNewCategoryScreen() {
        let newCategoryViewController = NewCategoryViewController()
        
        newCategoryViewController.onCategoryCreated = { [weak self] title in
            guard let self else { return }
            self.viewModel.addCategory(with: title)
        }
        
        navigationController?.pushViewController(newCategoryViewController, animated: true)
    }
}
