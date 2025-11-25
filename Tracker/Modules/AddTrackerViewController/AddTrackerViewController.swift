import UIKit

final class AddTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    
    let characterLimit = 38
    var selectedCategory: TrackerCategory = TrackerCategory(title: "Важное", trackers: [])
    
    var isTitleValid = false
    
    var onCreateTracker: ((Tracker) -> Void)?
    
    // MARK: - Private Properties
    
    private let textField = UITextField()
    private let textFieldContainer = UIView()
    
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    private let limitLabel = UILabel()
    
    private let mainStack = UIStackView()
    
    private let tableViewContainer = UIView()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        return tableView
    }()
    
    private var settingsTableView: TrackerSettingsTableView?
    
    private var selectedWeekdays = Set<Weekday>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configureAppearance()
        setupConstraints()
        setupActions()
        setupTrackerSettingsTableView()
        
        setupHideKeyboardGesture()
        
        updateLimitLayout(isTooLong: false)
        
        updateCreateButtonState()
        
    }
    
    // MARK: - Public Methods
    
    // MARK: - UpdateLimitLayout
    
    func updateLimitLayout(isTooLong: Bool) {
        if isTooLong {
            
            limitLabel.isHidden = false
            
            mainStack.spacing = 24
            mainStack.setCustomSpacing(8, after: textFieldContainer)
            mainStack.setCustomSpacing(32, after: limitLabel)
        } else {
            
            limitLabel.isHidden = true
            
            mainStack.spacing = 24
            mainStack.setCustomSpacing(24, after: textFieldContainer)
        }
    }
    
    // MARK: - UpdateCreateButtonState
    
    func updateCreateButtonState() {
        
        let hasSchedule = !selectedWeekdays.isEmpty
        
        let isFormValid = isTitleValid && hasSchedule
        
        createButton.isEnabled = isFormValid
        
        if isFormValid {
            createButton.backgroundColor = .blackYP
            createButton.setTitleColor(.whiteYP, for: .normal)
        } else {
            createButton.backgroundColor = .grayStatic
            createButton.setTitleColor(.whiteStatic, for: .normal)
        }
    }
    
    // MARK: - Private Methods
    
    // MARK: - Add Subviews
    
    private func addSubviews() {
        view.addSubviews([mainStack, cancelButton, createButton])
        
        mainStack.addArrangedSubview(textFieldContainer)
        mainStack.addArrangedSubview(limitLabel)
        mainStack.addArrangedSubview(tableViewContainer)
        
        textFieldContainer.addSubview(textField)
        tableViewContainer.addSubview(tableView)
    }
    
    // MARK: - Configure Appearance
    
    private func configureAppearance() {
        view.backgroundColor = .whiteYP
        
        //MainStack
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        mainStack.spacing = 24
        
        // NavBar Title
        title = "Новая привычка"
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
        
        // TextField + textFieldContainer
        let placeholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [
                .foregroundColor: UIColor(resource: .grayStatic),
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        textField.attributedPlaceholder = placeholder
        textField.textAlignment = .left
        textField.textColor = .blackYP
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .go
        textField.enablesReturnKeyAutomatically = true
        
        textFieldContainer.backgroundColor = .backgroundYP
        textFieldContainer.layer.cornerRadius = 16
        textFieldContainer.clipsToBounds = true
        
        // LimitLabel
        limitLabel.text = "Ограничение 38 символов"
        limitLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        limitLabel.textAlignment = .center
        limitLabel.textColor = .redStatic
        limitLabel.isHidden = true
        
        // CancelButton
        cancelButton.backgroundColor = .clear
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.redStatic.cgColor
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(.redStatic, for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        
        // CreateButton
        createButton.backgroundColor = .grayStatic
        createButton.layer.cornerRadius = 16
        createButton.setTitle("Создать", for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.setTitleColor(.whiteStatic, for: .normal)
        createButton.titleLabel?.textAlignment = .center
        
        // TableViewContainer
        tableViewContainer.backgroundColor = .backgroundYP
        tableViewContainer.layer.cornerRadius = 16
        tableViewContainer.layer.masksToBounds = true
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        [mainStack, textField, textFieldContainer, limitLabel, cancelButton, createButton, tableView, tableViewContainer].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            textFieldContainer.heightAnchor.constraint(equalToConstant: 75),
            
            textField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: textFieldContainer.centerYAnchor),
            
            limitLabel.centerXAnchor.constraint(equalTo: textFieldContainer.centerXAnchor),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor),
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            
            tableViewContainer.heightAnchor.constraint(equalToConstant: 150),
            
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableViewContainer.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
    }
    
    // MARK: - Setup Actions
    
    private func setupActions() {
        textField.delegate = self
        
        cancelButton.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard createButton.isEnabled else { return }
        
        let tracker = Tracker(
            id: UUID(),
            name: textField.text?.trimmed ?? "",
            color: .staticSelection5, //заглушка временно
            emoji: "🙂", // заглушка временно
            schedule: Array(selectedWeekdays)
            )
        
        onCreateTracker?(tracker)
        
        dismiss(animated: true)
    }
    
    // MARK: - Setup TrackerSettingsTableView
    
    private func setupTrackerSettingsTableView() {
        settingsTableView = TrackerSettingsTableView(tableView: tableView)
        
        settingsTableView?.onSelectRow = { [weak self ] index in
            guard let self else { return }
            
            switch index {
                
            case 0:
                print("Тап по строке Категория")
                // TODO: открыть экран категорий
                // self.openCategoryScreen()
                
            case 1:
                self.openScheduleScreen()
                
            default:
                break
            }
        }
        
        settingsTableView?.updateCategorySubtitle(selectedCategory.title)
    }
    
    // MARK: - SetupHideKeyboardGesture
    
    private func setupHideKeyboardGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - OpenScheduleScreen
    
    private func openScheduleScreen() {
        let scheduleViewController = ScheduleViewController()
        
        scheduleViewController.onScheduleSelected = { [weak self] weekdays in
            guard let self else { return }
            
            self.selectedWeekdays = weekdays
            self.updateScheduleSubtitle()
            
            self.updateCreateButtonState()
        }
        
        navigationController?.pushViewController(scheduleViewController, animated: true)
    }
    
    // MARK: - UpdateScheduleSubtitle
    
    private func updateScheduleSubtitle() {
        let weekdaysArray = Array(selectedWeekdays).sorted { $0.rawValue < $1.rawValue }
        
        if weekdaysArray.isEmpty {
            settingsTableView?.updateScheduleSubtitle(nil)
            return
        }
        
        if weekdaysArray.count == Weekday.allCases.count {
            settingsTableView?.updateScheduleSubtitle("Каждый день")
            return
        }
        
        let subtitle = weekdaysArray
            .map { $0.shortTitle }
            .joined(separator: ", ")
        
        settingsTableView?.updateScheduleSubtitle(subtitle)
    }
}
