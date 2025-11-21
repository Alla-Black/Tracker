import UIKit

final class AddTrackerViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let textFieldContainer = UIView()
    
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    private let tableViewContainer = UIView()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        return tableView
    }()
    
    private var settingsTableView: TrackerSettingsTableView?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configureAppearance()
        setupConstraints()
        setupActions()
        setupTrackerSettingsTableView()
        
    }
    
    // MARK: - Private Methods
    
    // MARK: - Add Subviews
    
    private func addSubviews() {
        view.addSubviews([titleLabel, textFieldContainer, cancelButton, createButton, tableViewContainer])
        textFieldContainer.addSubview(textField)
        tableViewContainer.addSubview(tableView)
    }
    
    // MARK: - Configure Appearance
    
    private func configureAppearance() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.text = "Новая привычка"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .blackYP
        
        
        let placeholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [
                .foregroundColor: UIColor(resource: .grayStatic),
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        textField.attributedPlaceholder = placeholder
        textField.textAlignment = .left
        textField.textColor = .whiteYP
        
        textFieldContainer.backgroundColor = .backgroundYP
        textFieldContainer.layer.cornerRadius = 16
        textFieldContainer.clipsToBounds = true
        
        cancelButton.backgroundColor = .clear
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.redStatic.cgColor
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(.redStatic, for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        
        createButton.backgroundColor = .grayStatic
        createButton.layer.cornerRadius = 16
        createButton.setTitle("Создать", for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.setTitleColor(.whiteStatic, for: .normal)
        createButton.titleLabel?.textAlignment = .center
        
        tableViewContainer.backgroundColor = .backgroundYP
        tableViewContainer.layer.cornerRadius = 16
        tableViewContainer.layer.masksToBounds = true
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        [textField, textFieldContainer, titleLabel, cancelButton, createButton, tableView, tableViewContainer].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            textFieldContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            textFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldContainer.heightAnchor.constraint(equalToConstant: 75),
            
            textField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -41),
            textField.centerYAnchor.constraint(equalTo: textFieldContainer.centerYAnchor),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor),
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            
            tableViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewContainer.topAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: 24),
            tableViewContainer.heightAnchor.constraint(equalToConstant: 150),
            
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableViewContainer.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
    }
    
    // MARK: - Setup Actions
    
    private func setupActions() {
        //TODO: Дописать методы для кнопок и поля с названием
        
    }
    
    // MARK: - Setup TrackerSettingsTableView
    
    private func setupTrackerSettingsTableView() {
        settingsTableView = TrackerSettingsTableView(tableView: tableView)
        
        settingsTableView?.onSelectRow = { index in
            
            switch index {
                
            case 0:
                print("Тап по строке Категория")
                // TODO: открыть экран категорий
                
            case 1:
                print("Тап по строке Расписание")
                // TODO: открыть экран с расписанием
                
            default:
                break
            }
        }
    }
}


#Preview {
    AddTrackerViewController()
}
