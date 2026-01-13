import UIKit

// MARK: - Enum TrackerSettingsRow

private enum TrackerSettingsRow: Int {
    case category
    case schedule
}

// MARK: - AddTrackerViewController

final class AddTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var onCreateTracker: ((Tracker) -> Void)?
    
    var selectedCategory: TrackerCategory = TrackerCategory(title: "", trackers: [])
    
    // MARK: - Private Properties
    
    private lazy var textField: UITextField = {
        let textField = ClearButtonInsetTextField()
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let params = CollectionLayoutParams(cellCount: 6, leftInset: 2, rightInset: 3, cellSpaсing: 5)
    
    private lazy var emojiColorCollection = EmojiColorCollectionView(using: params, collectionView: collectionView)
    
    private var collectionHeightConstraint: NSLayoutConstraint?
    
    private var selectedWeekdays = Set<Weekday>()
    
    private var isTitleValid = false
    
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    
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
        
        _ = emojiColorCollection
        
        updateLimitLayout(isTooLong: false)
        updateCreateButtonState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionHeightConstraint?.constant = contentHeight
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
        mainStack.addArrangedSubview(collectionView)
        
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
        
        // CollectionView
        collectionView.isScrollEnabled = false
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        [scrollView, contentView, mainStack, textField,
         textFieldContainer, limitLabel, cancelButton, createButton, tableView, tableViewContainer, collectionView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            textFieldContainer.heightAnchor.constraint(equalToConstant: 75),
            
            textField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor),
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
        
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionHeightConstraint?.isActive = true
    }
    
    // MARK: - Setup Actions
    
    private func setupDelegates() {
        textField.delegate = self
        emojiColorCollection.selectionDelegate = self
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard createButton.isEnabled else { return }
        
        guard let emoji = selectedEmoji,
              let color = selectedColor
        else {
            return
        }
        
        let tracker = Tracker(
            id: UUID(),
            name: textField.text?.trimmed ?? "",
            color: color,
            emoji: emoji,
            schedule: Array(selectedWeekdays)
            )
        
        onCreateTracker?(tracker)
        dismiss(animated: true)
    }
    
    // MARK: - Setup TrackerSettingsTableView
    
    private func setupTrackerSettingsTableView() {
        settingsTableView.onSelectRow = { [weak self ] index in
            guard
                let self,
            let row = TrackerSettingsRow(rawValue: index) else { return }
            
            switch row {
            case .category:
                self.openCategoryScreen()
                
            case .schedule:
                self.openScheduleScreen()
            }
        }
        
        settingsTableView.updateCategorySubtitle(selectedCategory.title)
    }
    
    // MARK: - UpdateLimitLayout
    
    private func updateLimitLayout(isTooLong: Bool) {
        mainStack.setCustomSpacing(16, after: tableViewContainer)
        
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
        
        let hasEmoji = selectedEmoji != nil
        let hasColor = selectedColor != nil
        let hasSchedule = !selectedWeekdays.isEmpty
        let hasCategory = !selectedCategory.title.isEmpty
        let isFormValid = isTitleValid && hasSchedule && hasColor && hasEmoji && hasCategory
        
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
            action: #selector(hideKeyboard(_:))
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        let tappedView = view.hitTest(location, with: nil)
        
        if let tappedView, tappedView.isDescendant(of: textFieldContainer) {
            return
        }
        
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
    
    // MARK: - OpenCategoryScreen
    
    private func openCategoryScreen() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let trackerCategoryStore = appDelegate.trackerCategoryStore
        
        let viewModel = CategoryListViewModel(trackerCategoryStore: trackerCategoryStore)
        
        let categoryListViewController = CategoryListViewController(viewModel: viewModel)
        
        categoryListViewController.preselectedCategoryTitle = selectedCategory.title
        
        categoryListViewController.onCategoryPicked = { [weak self] title in
            guard let self else { return }
            
            self.selectedCategory = TrackerCategory(title: title, trackers: [])
            self.settingsTableView.updateCategorySubtitle(title)
            self.updateCreateButtonState()
        }
        
        navigationController?.pushViewController(categoryListViewController, animated: true)
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

// MARK: - Extension EmojiColorSelectionDelegate

extension AddTrackerViewController: EmojiColorSelectionDelegate {
    func emojiColorCollectionView(_ manager: EmojiColorCollectionView, didSelectColor color: UIColor) {
        selectedColor = color
        updateCreateButtonState()
    }
    
    func emojiColorCollectionView(_ manager: EmojiColorCollectionView, didSelectEmoji emoji: String) {
        selectedEmoji = emoji
        updateCreateButtonState()
    }
}
