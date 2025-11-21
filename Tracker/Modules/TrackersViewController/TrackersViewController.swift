import UIKit

final class TrackersViewController: UIViewController {
 
    // MARK: - Private Properties
    
    private let titleNameLabel = UILabel()
    private let addTrackerButton = UIButton()
    private let searchBar = UISearchBar()
    
    private let stubImage = UIImageView()
    private let stubLabel = UILabel()
    
    private let stubContainer = UIView()
    private let titleContainer = UIView()
    
    private let datePickerView = DatePickerView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    private let params = CollectionLayoutParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpaсing: 9)
    
    private var trackersCollectionView: TrackersCollectionView?
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        addSubviews()
        configureAppearance()
        setupConstraints()
        setupActions()
        
        trackersCollectionView = TrackersCollectionView(using: params, collectionView: collectionView)
        
        categories = TrackersMockData.makeCategories()
        updateCollection(with: categories)
    }
    
    // MARK: - Private Methods
    
    // MARK: - Setup UI
    
    private func addSubviews() {
        view.addSubview(titleContainer)
        titleContainer.addSubviews([titleNameLabel, addTrackerButton, searchBar, datePickerView])
        
        view.addSubview(stubContainer)
        stubContainer.addSubviews([stubImage, stubLabel])
        
        view.addSubview(collectionView)
    }
    
    private func configureAppearance() {
        titleNameLabel.text = "Трекеры"
        titleNameLabel.textColor = UIColor(resource: .blackYP)
        titleNameLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleNameLabel.textAlignment = .left
        
        stubImage.image = UIImage(resource: .trackersPlaceholder)
        
        stubLabel.text = "Что будем отслеживать?"
        stubLabel.textColor = UIColor(resource: .blackYP)
        stubLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        stubLabel.textAlignment = .center
        
        datePickerView.setContentHuggingPriority(.required, for: .horizontal)
        datePickerView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        var config = addTrackerButton.configuration ?? UIButton.Configuration.plain()
        let plusImage = UIImage(resource: .addTracker).withRenderingMode(.alwaysTemplate)
        config.image = plusImage
        config.contentInsets = .init(top: 12, leading: 0, bottom: 12, trailing: 0)
        config.baseForegroundColor = UIColor(resource: .blackYP)
        addTrackerButton.configuration = config
        addTrackerButton.imageView?.contentMode = .scaleAspectFit
        addTrackerButton.contentHorizontalAlignment = .leading
        
        let placeholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                .foregroundColor: UIColor(resource: .graySearch),
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        searchBar.searchTextField.attributedPlaceholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .blackYP
        
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
    
    private func setupActions() {
        addTrackerButton.addTarget(
            self,
            action: #selector(didTapAddTrackerButton),
            for: .touchUpInside
        )
        
        searchBar.delegate = self
    }
    
    @objc private func didTapAddTrackerButton() {
        //TODO: реализовать функционал нажатия на кнопку
    }
    
    private func updateCollection(with categories: [TrackerCategory]) {
        self.categories = categories
        trackersCollectionView?.update(with: categories)
        
        let hasTrackers = categories.contains { !$0.trackers.isEmpty }
        
        stubContainer.isHidden = hasTrackers
        collectionView.isHidden = !hasTrackers
        
    }
    
}

#Preview {
    TabBarController()
}
