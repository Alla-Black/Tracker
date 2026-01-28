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
        label.text = AppStrings.Trackers.navigationTitle
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
    private lazy var searchTextField: UISearchTextField = {
        let field = UISearchTextField()
        field.textColor = UIColor(resource: .blackYP)
        
        let placeholder = NSAttributedString(
            string: AppStrings.Common.searchPlaceholder,
            attributes: [
                .foregroundColor: UIColor(resource: .graySearch),
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        field.attributedPlaceholder = placeholder
        field.borderStyle = .none
        field.backgroundColor = UIColor(resource: .grayTextField)
        field.layer.cornerRadius = 10
        field.clipsToBounds = true
        field.clearButtonMode = .never
        field.tintColor = UIColor(resource: .blueStatic)
        
        let image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor(resource: .graySearch)
        field.leftView = imageView
        field.leftViewMode = .always
        
        field.addTarget(self, action: #selector(searchFieldEvent(_:)), for: .editingChanged)
        field.addTarget(self, action: #selector(searchFieldEvent(_:)), for: .editingDidBegin)
        field.addTarget(self, action: #selector(searchFieldEvent(_:)), for: .editingDidEnd)
        return field
    }()
    
    private lazy var cancelSearchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppStrings.Common.сancelButton, for: .normal)
        button.setTitleColor(UIColor(resource: .blueStatic), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.titleLabel?.textAlignment = .center
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapCancelSearch), for: .touchUpInside)
        return button
    }()
    
    private lazy var stubImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .trackersPlaceholder)
        return imageView
    }()
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = AppStrings.Trackers.emptyStateTitle
        label.textColor = UIColor(resource: .blackYP)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    private lazy var filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppStrings.Trackers.filtersButtonTitle, for: .normal)
        button.setTitleColor(UIColor(resource: .whiteStatic), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = UIColor(resource: .blueStatic)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapFiltersButton), for: .touchUpInside)
        return button
    }()
    
    private let stubContainer = UIView()
    private let titleContainer = UIView()
    
    private let params = CollectionLayoutParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpaсing: 9)
    private lazy var trackersCollectionView = TrackersCollectionView(using: params, collectionView: collectionView)
    
    private var categories: [TrackerCategory] = []
    private let viewModel = TrackersViewModel()
    private var searchTrailingToContainer: NSLayoutConstraint?
    private var searchTrailingToCancel: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configureAppearance()
        updateCollectionBottomInset()
        setupConstraints()
        setupDelegates()
        updateCancelButtonVisibility()
        bindViewModel()
        reloadFromStore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.shared.reportUIEvent(.open, screen: AnalyticsScreen.main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.shared.reportUIEvent(.close, screen: AnalyticsScreen.main)
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
        titleContainer.addSubviews([titleNameLabel, addTrackerButton, searchTextField, cancelSearchButton, datePickerView])
        
        view.addSubview(stubContainer)
        stubContainer.addSubviews([stubImage, stubLabel])
        
        view.addSubview(collectionView)
        view.addSubview(filtersButton)
    }
    
    private func configureAppearance() {
        view.backgroundColor = .whiteYP
        titleContainer.backgroundColor = .whiteYP
        collectionView.backgroundColor = .whiteYP
        
        var config = addTrackerButton.configuration ?? UIButton.Configuration.plain()
        let plusImage = UIImage(resource: .addTracker).withRenderingMode(.alwaysTemplate)
        config.image = plusImage
        config.contentInsets = .init(top: 12, leading: 0, bottom: 12, trailing: 0)
        config.baseForegroundColor = UIColor(resource: .blackYP)
        addTrackerButton.configuration = config
    }
    
    private func updateCollectionBottomInset() {
        let bottomInset: CGFloat = 16 + 50 + 16
        collectionView.contentInset.bottom = bottomInset
        collectionView.verticalScrollIndicatorInsets.bottom = bottomInset
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        [titleContainer, titleNameLabel, addTrackerButton, searchTextField, cancelSearchButton, stubContainer, stubImage, stubLabel, datePickerView, collectionView, filtersButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleContainer.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            
            datePickerView.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -16),
            datePickerView.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 5),
            datePickerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 77),
            
            titleNameLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 44),
            titleNameLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
            
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            addTrackerButton.centerYAnchor.constraint(equalTo: datePickerView.centerYAnchor),
            addTrackerButton.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
            
            searchTextField.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
            
            searchTextField.topAnchor.constraint(equalTo: titleNameLabel.bottomAnchor, constant: 7),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            
            cancelSearchButton.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -16),
            cancelSearchButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            
            stubContainer.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
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
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 114)
        ])
        
        searchTrailingToContainer = searchTextField.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -16)
        searchTrailingToCancel = searchTextField.trailingAnchor.constraint(equalTo: cancelSearchButton.leadingAnchor, constant: -5)
        
        searchTrailingToContainer?.isActive = true
        searchTrailingToCancel?.isActive = false
    }
    
    // MARK: - Actions wiring
    
    private func setupDelegates() {
        datePickerView.delegate = self
        trackersCollectionView.delegate = self
    }
    
    @objc private func didTapAddTrackerButton() {
        AnalyticsService.shared.reportUIEvent(.click, screen: AnalyticsScreen.main, item: AnalyticsItem.addTrack)
        
        let addTracker = AddTrackerViewController()
        
        if let defaultCategory = categories.first {
            addTracker.selectedCategory = defaultCategory
        }
        
        addTracker.onSubmitTracker = { [weak self] tracker, categoryTitle in
            guard let self else { return }
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
    
    @objc private func didTapFiltersButton() {
        AnalyticsService.shared.reportUIEvent(.click, screen: AnalyticsScreen.main, item: AnalyticsItem.filter)
        
        let current = viewModel.currentFilter
        
        let filtersVM = FiltersViewModel(selectedFilter: current)
        let filtersVC = FiltersViewController(viewModel: filtersVM)
        
        filtersVC.onSelectFilter = { [weak self] filter in
            guard let self else { return }
            
            self.viewModel.setFilter(filter)
            
            guard filter != .today else { return }
            
            let date = self.datePickerView.selectedDate
            let ids = self.dataProvider.completedTrackerIDs(on: date)
            self.viewModel.setCompletedTrackerIDs(ids)
        }
        
        let nav = UINavigationController(rootViewController: filtersVC)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }
    
    // MARK: - Search UI helpers
    
    private func updateCancelButtonVisibility() {
        let text = searchTextField.text ?? ""
        let shouldShow = searchTextField.isFirstResponder || !text.isEmpty
        
        cancelSearchButton.isHidden = !shouldShow
        
        searchTrailingToContainer?.isActive = !shouldShow
        searchTrailingToCancel?.isActive = shouldShow
    }
    
    @objc private func didTapCancelSearch() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        searchFieldEvent(searchTextField)
    }
    
    @objc private func searchFieldEvent(_ sender: UISearchTextField) {
        let text = sender.text ?? ""
        viewModel.setSearchText(text)
        updateCancelButtonVisibility()
    }
    
    // MARK: - Binding + Apply Empty State
    
    private func bindViewModel() {
        viewModel.onVisibleCategoriesChanged = { [weak self] categories in
            guard let self else { return }
            self.visibleCategories = categories
            self.trackersCollectionView.update(with: categories)
        }
        
        viewModel.onEmptyStateChanged = { [weak self] state in
            self?.applyEmptyState(state)
        }
        
        viewModel.onFilterChanged = { [weak self] filter in
            guard let self else { return }
            
            self.applyFilterButtonStyle(isActive: filter.isActiveFilter)
            
            guard filter == .today else { return }
            
            let today = Date()
            self.datePickerView.setSelectedDate(today, sendDelegate: false)
            
            let ids = self.dataProvider.completedTrackerIDs(on: today)
            self.viewModel.setCompletedTrackerIDs(ids)
        }
        
        applyFilterButtonStyle(isActive: viewModel.currentFilter.isActiveFilter)
    }
    
    private func applyFilterButtonStyle(isActive: Bool) {
        let titleColor: UIColor = isActive
        ? UIColor(resource: .redStatic)
        : UIColor(resource: .whiteStatic)
        
        filtersButton.setTitleColor(titleColor, for: .normal)
    }
    
    private func applyEmptyState(_ state: TrackersViewModel.EmptyState) {
        switch state {
        case .none:
            stubContainer.isHidden = true
            collectionView.isHidden = false
            filtersButton.isHidden = false
            
        case .emptyList:
            stubContainer.isHidden = false
            collectionView.isHidden = true
            filtersButton.isHidden = true
            stubImage.image = UIImage(resource: .trackersPlaceholder)
            stubLabel.text = AppStrings.Trackers.emptyStateTitle
            
        case .noResults:
            stubContainer.isHidden = false
            collectionView.isHidden = true
            filtersButton.isHidden = false
            stubImage.image = UIImage(resource: .notFound)
            stubLabel.text = AppStrings.Trackers.noResultsTitle
        }
    }
    
    // MARK: - Data loading
    
    func reloadFromStore() {
        let storedCategories = dataProvider.getAllCategories()
        categories = storedCategories
        
        let date = datePickerView.selectedDate
        viewModel.setCategories(storedCategories)
        viewModel.setSelectedDate(date)
        viewModel.setCompletedTrackerIDs(dataProvider.completedTrackerIDs(on: date))
    }
}

// MARK: - TrackersDataProviderDelegate Extension

extension TrackersViewController: TrackersDataProviderDelegate {
    func didUpdate(_ update: TrackersStoreUpdate) {
        reloadFromStore()
    }
}

// MARK: - DatePickerViewDelegate Extension

extension TrackersViewController: DatePickerViewDelegate {
    func datePickerView(_ view: DatePickerView, didChangeDate date: Date) {
        viewModel.setSelectedDate(date)
        viewModel.setCompletedTrackerIDs(dataProvider.completedTrackerIDs(on: date))
    }
}

// MARK: - TrackersCollectionViewDelegate Extension

extension TrackersViewController: TrackersCollectionViewDelegate {
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView, didTapPlusFor tracker: Tracker, at indexPath: IndexPath) {
        
        let selectedDate = datePickerView.selectedDate
        
        let today = normalizedDate(Date())
        let normalizedSelected = normalizedDate(selectedDate)
        
        guard normalizedSelected <= today else {
            return
        }
        
        AnalyticsService.shared.reportUIEvent(.click, screen: AnalyticsScreen.main, item: AnalyticsItem.track)
        
        do {
            try dataProvider.toggleRecord(for: tracker, on: selectedDate)
            let ids = dataProvider.completedTrackerIDs(on: selectedDate)
            viewModel.setCompletedTrackerIDs(ids)
        } catch {
            assertionFailure("Не удалось изменить запись трекера: \(error)")
        }
    }
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView,
        completedCountFor tracker: Tracker) -> Int {
        
        return completedCount(for: tracker)
    }
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView,
        isCompleted tracker: Tracker) -> Bool {
        let date = datePickerView.selectedDate
        
        return dataProvider.isTrackerCompleted(tracker, on: date)
    }
    
    func numberOfSections(in collectionView: TrackersCollectionView) -> Int {
        return visibleCategories.count
    }
    
    func trackersCollectionView(
        _ collectionView: TrackersCollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard visibleCategories.indices.contains(section) else { return 0 }
        return visibleCategories[section].trackers.count
    }
    
    func trackersCollectionView(
        _ collectionView: TrackersCollectionView,
        trackerAt indexPath: IndexPath
    ) -> Tracker {
        return visibleCategories[indexPath.section].trackers[indexPath.item]
    }
    
    func trackersCollectionView(
        _ collectionView: TrackersCollectionView,
        titleForSection section: Int
    ) -> String {
        guard visibleCategories.indices.contains(section) else { return "" }
        return visibleCategories[section].title
    }
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView, didRequestDeleteAt indexPath: IndexPath) {
        let alert = UIAlertController(
            title: AppStrings.Trackers.deleteAlertTitle,
            message: nil,
            preferredStyle: .actionSheet
        )

        let delete = UIAlertAction(title: AppStrings.Common.deleteButton, style: .destructive) { [weak self] _ in
            guard let self else { return }
            do {
                try self.dataProvider.delete(at: indexPath)
            } catch {
                assertionFailure("Не удалось удалить трекер: \(error)")
            }
        }

        let cancel = UIAlertAction(title: AppStrings.Common.сancelButton, style: .cancel)

        alert.addAction(delete)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    func trackersCollectionView(_ collectionView: TrackersCollectionView, didRequestEdit tracker: Tracker) {
        let completedDays = dataProvider.completedCount(for: tracker)
        
        let editVC = AddTrackerViewController(mode: .edit(tracker: tracker, completedDays: completedDays))
        
        if let category = categories.first(where: { category in
            category.trackers.contains(where: { $0.id == tracker.id })
        }) {
            editVC.selectedCategory = category
        }
        
        editVC.onSubmitTracker = { [weak self] updatedTracker, categoryTitle in
            guard let self else { return }
            do {
                try self.dataProvider.update(updatedTracker, categoryTitle: categoryTitle)
            } catch {
                assertionFailure("Не удалось обновить трекер: \(error)")
            }
        }
        
        let nav = UINavigationController(rootViewController: editVC)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }
}
