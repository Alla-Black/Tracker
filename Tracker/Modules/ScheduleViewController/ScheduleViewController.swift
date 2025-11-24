import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var onScheduleSelected: ((Set<Weekday>) -> Void)?
    
    // MARK: - Private Properties
    
    private let doneButton = UIButton()
    
    private let tableViewContainer = UIView()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        return tableView
    }()
    
    private var scheduleTableView: ScheduleTableView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configureAppearance()
        setupConstraints()
        setupActions()
        setupScheduleTableView()
      
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        view.addSubviews([tableViewContainer, doneButton])
        tableViewContainer.addSubview(tableView)
    }
    
    private func configureAppearance() {
        view.backgroundColor = .whiteYP
        
        title = "Расписание"
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
            
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = nil
        }
        
        tableViewContainer.backgroundColor = .backgroundYP
        tableViewContainer.layer.cornerRadius = 16
        tableViewContainer.layer.masksToBounds = true
        
        doneButton.backgroundColor = .blackYP
        doneButton.layer.cornerRadius = 16
        doneButton.setTitle("Готово", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        doneButton.setTitleColor(.whiteYP, for: .normal)
        doneButton.titleLabel?.textAlignment = .center
        
    }
    
    private func setupConstraints() {
        [tableViewContainer, tableView, doneButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            tableViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewContainer.heightAnchor.constraint(equalToConstant: 525),
            
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupScheduleTableView() {
        scheduleTableView = ScheduleTableView(tableView: tableView)
    }
    
    private func setupActions() {
        doneButton.addTarget(
            self,
            action: #selector(doneButtonTapped),
            for: .touchUpInside
            )
    }
    
    @objc private func doneButtonTapped() {
        let selected = scheduleTableView?.getSelectedWeekdays() ?? []
        
        onScheduleSelected?(selected)
        
        navigationController?.popViewController(animated: true)
    }
    
}
