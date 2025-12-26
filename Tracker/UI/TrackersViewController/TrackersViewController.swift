import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Public Properties
    
    lazy var datePickerView: DatePickerView = {
        let view = DatePickerView()
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }()
    
    var completedTrackers: [TrackerRecord] = []
    
    var visibleCategories: [TrackerCategory] = []
    
    lazy var dataProvider: TrackersDataProviderProtocol = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure("TrackersViewController error: failed to get AppDelegate")
        }
        
        let trackerStore = appDelegate.trackerStore
        let recordStore = appDelegate.trackerRecordStore
        
        return TrackersDataProvider(
            trackerStore: trackerStore,
            recordStore: recordStore,
            delegate: self
        )
    }()
 
    // MARK: - Private Properties
    
    private lazy var titleNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = UIColor(resource: .blackYP)
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .leading
        button.addTarget(
            self,
            action: #selector(didTapAddTrackerButton),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .blackYP
        return searchBar
    }()
    
    private lazy var stubImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .trackersPlaceholder)
        return imageView
    }()
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = UIColor(resource: .blackYP)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stubContainer: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var titleContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    private let params = CollectionLayoutParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpaсing: 9)
    
    private lazy var trackersCollectionView = TrackersCollectionView(using: params, collectionView: collectionView)
    
    private var categories: [TrackerCategory] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        addSubviews()
        configureAppearance()
        setupConstraints()
        setupDelegates()
        
        reloadFromStore()
    }
    
    // MARK: - Tracker completion helpers
    
    func normalizedDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: date)
    }
    
    func isTrackerCompleted(_ tracker: Tracker, on date: Date) -> Bool {
        let normalized = normalizedDate(date)
        let calendar = Calendar.current
        
        return completedTrackers.contains { record in
            record.trackerId == tracker.id && calendar.isDate(normalizedDate(record.date), inSameDayAs: normalized)
        }
    }
    
    func completedCount(for tracker: Tracker) -> Int {
        return dataProvider.completedCount(for: tracker)
    }
    
    // MARK: - Setup UI
    
    private func addSubviews() {
        view.addSubview(titleContainer)
        titleContainer.addSubviews([titleNameLabel, addTrackerButton, searchBar, datePickerView])
        
        view.addSubview(stubContainer)
        stubContainer.addSubviews([stubImage, stubLabel])
        
        view.addSubview(collectionView)
    }
    
    private func configureAppearance() {
        // addTrackerButton
        var config = addTrackerButton.configuration ?? UIButton.Configuration.plain()
        let plusImage = UIImage(resource: .addTracker).withRenderingMode(.alwaysTemplate)
        config.image = plusImage
        config.contentInsets = .init(top: 12, leading: 0, bottom: 12, trailing: 0)
        config.baseForegroundColor = UIColor(resource: .blackYP)
        addTrackerButton.configuration = config
        
        // searchBar
        let placeholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                .foregroundColor: UIColor(resource: .graySearch),
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        searchBar.searchTextField.attributedPlaceholder = placeholder
        
        let icon = UIImage(systemName: "magnifyingglass")?
            .withTintColor(UIColor(resource: .graySearch), renderingMode: .alwaysOriginal)
        searchBar.setImage(icon, for: .search, state: .normal)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        let field = searchBar.searchTextField
        
        [titleContainer, titleNameLabel, addTrackerButton, searchBar, stubContainer, stubImage, stubLabel, datePickerView, field, collectionView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleContainer.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            
            datePickerView.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -16),
            datePickerView.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 5),
            datePickerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 77),
            
            
            titleNameLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 44),
            titleNameLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
            
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            addTrackerButton.centerYAnchor.constraint(equalTo: datePickerView.centerYAnchor),
            addTrackerButton.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
            
            searchBar.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -16),
            searchBar.topAnchor.constraint(equalTo: titleNameLabel.bottomAnchor, constant: 7),
            
            field.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),
            field.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            field.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            
            stubContainer.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            stubContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stubContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stubContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            stubImage.centerXAnchor.constraint(equalTo: stubContainer.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: stubContainer.centerYAnchor),
            
            stubLabel.centerXAnchor.constraint(equalTo: stubImage.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            stubLabel.leadingAnchor.constraint(greaterThanOrEqualTo: stubContainer.leadingAnchor, constant: 16),
            stubLabel.trailingAnchor.constraint(lessThanOrEqualTo: stubContainer.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: titleContainer.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Actions wiring
    
    private func setupDelegates() {
        searchBar.delegate = self
        datePickerView.delegate = self
        trackersCollectionView.delegate = self
    }
    
    @objc private func didTapAddTrackerButton() {
        let addTracker = AddTrackerViewController()
        
        if let defaultCategory = categories.first {
            addTracker.selectedCategory = defaultCategory
        }
        
        addTracker.onCreateTracker = { [weak self] tracker in
            guard let self else { return }
            
            let categoryTitle = addTracker.selectedCategory.title
            
            do {
                try self.dataProvider.add(tracker, categoryTitle: categoryTitle)
            } catch {
                assertionFailure("Не удалось сохранить трекер: \(error)")
            }
        }
        
        let navigationController = UINavigationController(rootViewController: addTracker)
        navigationController.modalPresentationStyle = .pageSheet
        
        present(navigationController, animated: true)
    }
    
    // MARK: - Filtering for date
    
    private func filteredCategories(for date: Date) -> [TrackerCategory] {
        guard let weekday = Weekday.from(date: date) else { return [] }
        
        let filtered = categories.map { category in
            let trackersForDay = category.trackers.filter { $0.schedule.contains(weekday) }
            
            return TrackerCategory(title: category.title, trackers: trackersForDay)
        }
        
        return filtered.filter { !$0.trackers.isEmpty }
    }
    
    func applyFilter(for date: Date) {
        visibleCategories = filteredCategories(for: date)
        
        trackersCollectionView.update(with: visibleCategories)
        
        let hasTrackers = visibleCategories.contains { !$0.trackers.isEmpty }
        
        stubContainer.isHidden = hasTrackers
        collectionView.isHidden = !hasTrackers
    }
    
    func reloadFromStore() {
        let currentDate = datePickerView.selectedDate
        
        let storedCategories = dataProvider.getAllCategories()
        categories = storedCategories
        applyFilter(for: currentDate)
    }
}

// MARK: - TrackersDataProviderDelegate Extension

extension TrackersViewController: TrackersDataProviderDelegate {
    func didUpdate(_ update: TrackersStoreUpdate) {
        reloadFromStore()
    }
}
