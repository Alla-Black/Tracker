import UIKit

final class AddTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var onCreateTracker: ((Tracker) -> Void)?
    
    var selectedCategory: TrackerCategory = TrackerCategory(title: "Важное", trackers: [])
    
    // MARK: - Private Properties
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.textColor = .blackYP
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .go
        textField.enablesReturnKeyAutomatically = true
        return textField
    }()
    
    private lazy var textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundYP
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.redStatic.cgColor
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.redStatic, for: .normal)
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .grayStatic
        button.layer.cornerRadius = 16
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.whiteStatic, for: .normal)
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(
            self,
            action: #selector(createButtonTapped),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var limitLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.textColor = .redStatic
        label.isHidden = true
        return label
    }()
    
    private lazy var mainStack: UIStackView = {
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        mainStack.spacing = 24
        return mainStack
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
    
    private lazy var settingsTableView =  TrackerSettingsTableView(tableView: tableView)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private var selectedWeekdays = Set<Weekday>()
    
    private var isTitleValid = false
    
    private let characterLimit = 38
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configureAppearance()
        setupConstraints()
        setupTrackerSettingsTableView()
        setupDelegates()
        setupHideKeyboardGesture()
        
        updateLimitLayout(isTooLong: false)
        updateCreateButtonState()
    }
    
    // MARK: - Private Methods
    
    // MARK: - Add Subviews
    
    private func addSubviews() {
        view.addSubviews([scrollView, cancelButton, createButton])
        
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStack)
        
        mainStack.addArrangedSubview(textFieldContainer)
        mainStack.addArrangedSubview(limitLabel)
        mainStack.addArrangedSubview(tableViewContainer)
        
        textFieldContainer.addSubview(textField)
        tableViewContainer.addSubview(tableView)
    }
    
    // MARK: - Configure Appearance
    
    private func configureAppearance() {
        view.backgroundColor = .whiteYP
        
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
        
        // TextField
        let placeholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [
                .foregroundColor: UIColor(resource: .grayStatic),
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        textField.attributedPlaceholder = placeholder
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        [scrollView, contentView, mainStack, textField,
         textFieldContainer, limitLabel, cancelButton, createButton, tableView, tableViewContainer].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),

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
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor)
        ])
    }
    
    // MARK: - Setup Actions
    
    private func setupDelegates() {
        textField.delegate = self
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
        settingsTableView.onSelectRow = { [weak self ] index in
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
        
        settingsTableView.updateCategorySubtitle(selectedCategory.title)
    }
    
    // MARK: - UpdateLimitLayout
    
    private func updateLimitLayout(isTooLong: Bool) {
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
    
   private func updateCreateButtonState() {
        
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
            settingsTableView.updateScheduleSubtitle(nil)
            return
        }
        
        if weekdaysArray.count == Weekday.allCases.count {
            settingsTableView.updateScheduleSubtitle("Каждый день")
            return
        }
        
        let subtitle = weekdaysArray
            .map { $0.shortTitle }
            .joined(separator: ", ")
        
        settingsTableView.updateScheduleSubtitle(subtitle)
    }
}

// MARK: - Extension UITextFieldDelegate

extension AddTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        let isTooLong = updatedText.count > characterLimit
        
        let trimmed = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
        let isEmpty = trimmed.isEmpty
        
        updateLimitLayout(isTooLong: isTooLong)
        
        isTitleValid = !isEmpty && !isTooLong
        updateCreateButtonState()
        
        return true
        
    }
}
