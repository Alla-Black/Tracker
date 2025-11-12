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
    
    private let dateContainer = UIView()
    private let datePicker = UIDatePicker()
    private let dateLabel = UILabel()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        addViewsToScreen()
    }
    
    // MARK: - Private Methods
    
    private func addViewsToScreen() {
        addSubviews()
        configureAppearance()
        setupConstraints()
        setupActions()
        
        func addSubviews() {
            view.addSubview(titleContainer)
            titleContainer.addSubviews([titleNameLabel, addTrackerButton, searchBar, dateContainer])
            
            view.addSubview(stubContainer)
            stubContainer.addSubviews([stubImage, stubLabel])
            
            dateContainer.addSubviews([dateLabel, datePicker])
            dateContainer.bringSubviewToFront(dateLabel)
        }
        
        func configureAppearance() {
            titleNameLabel.text = "Трекеры"
            titleNameLabel.textColor = UIColor(resource: .blackYP)
            titleNameLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
            titleNameLabel.textAlignment = .left
            
            datePicker.preferredDatePickerStyle = .compact
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "ru_RU")
            datePicker.alpha = 0.02
            datePicker.setContentHuggingPriority(.defaultLow, for: .horizontal)
            datePicker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            dateLabel.text = DateFormatterHelper.dateFormatter.string(from: datePicker.date)
            dateLabel.textColor = UIColor(resource: .blackYP).resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
            dateLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            dateLabel.setContentHuggingPriority(.required, for: .horizontal)
            dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            dateContainer.backgroundColor = UIColor(red: 0xF0/255.0, green: 0xF0/255.0, blue: 0xF0/255.0, alpha: 1)
            dateContainer.layer.cornerRadius = 8
            
            stubImage.image = UIImage(resource: .trackersPlaceholder)
            
            stubLabel.text = "Что будем отслеживать?"
            stubLabel.textColor = UIColor(resource: .blackYP)
            stubLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            stubLabel.textAlignment = .center
            
            var config = addTrackerButton.configuration ?? UIButton.Configuration.plain()
            let plusImage = UIImage(resource: .addTracker).withRenderingMode(.alwaysTemplate)
            config.image = plusImage
            config.contentInsets = .init(top: 12, leading: 0, bottom: 12, trailing: 0)
            config.baseForegroundColor = UIColor(resource: .blackYP)
            addTrackerButton.configuration = config
            addTrackerButton.imageView?.contentMode = .scaleAspectFit
            addTrackerButton.contentHorizontalAlignment = .leading
            
            searchBar.placeholder = "Поиск"
            searchBar.searchBarStyle = .minimal
        }
        
        func setupConstraints() {
            let field = searchBar.searchTextField
            
            [titleContainer, titleNameLabel, datePicker, addTrackerButton, searchBar, stubContainer, stubImage, stubLabel, dateContainer, dateLabel, field].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
            
            NSLayoutConstraint.activate([
                titleContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                titleContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                titleContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                titleContainer.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -10),
                
                dateContainer.heightAnchor.constraint(equalToConstant: 34),
                dateContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 77),
                dateContainer.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -16),
                dateContainer.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 5),
                
                datePicker.leadingAnchor.constraint(equalTo: dateContainer.leadingAnchor),
                datePicker.trailingAnchor.constraint(equalTo: dateContainer.trailingAnchor),
                datePicker.topAnchor.constraint(equalTo: dateContainer.topAnchor),
                datePicker.bottomAnchor.constraint(equalTo: dateContainer.bottomAnchor),
                
                dateLabel.leadingAnchor.constraint(equalTo: dateContainer.leadingAnchor, constant: 12),
                dateLabel.trailingAnchor.constraint(equalTo: dateContainer.trailingAnchor, constant: -12),
                dateLabel.topAnchor.constraint(equalTo: dateContainer.topAnchor, constant: 6),
                dateLabel.bottomAnchor.constraint(equalTo: dateContainer.bottomAnchor, constant: -6),
                
                titleNameLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 44),
                titleNameLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
                
                addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
                addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
                addTrackerButton.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor),
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
                stubLabel.trailingAnchor.constraint(lessThanOrEqualTo: stubContainer.trailingAnchor, constant: -16)
            ])
        }
        
        func setupActions() {
            datePicker.addTarget(
                self,
                action: #selector(dateChanged),
                for: .valueChanged
            )
            
            addTrackerButton.addTarget(
                self,
                action: #selector(didTapAddTrackerButton),
                for: .touchUpInside
            )
            
            searchBar.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddTrackerButton() {
        
    }
    
    @objc private func dateChanged() {
        dateLabel.text = DateFormatterHelper.dateFormatter.string(from: datePicker.date)
    }

}

