import UIKit

final class NewCategoryViewController: UIViewController {
    // MARK: - Private Properties
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.textColor = .blackYP
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .go
        textField.enablesReturnKeyAutomatically = true
        
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundYP
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .grayStatic
        button.layer.cornerRadius = 16
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.whiteYP, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(
            self,
            action: #selector(doneButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configureAppearance()
        setupConstraints()
        updateCreateButtonState()
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        view.addSubviews([textFieldContainer, doneButton])
        textFieldContainer.addSubview(textField)
    }
    
    private func configureAppearance() {
        view.backgroundColor = .whiteYP
        
        // NavBar Title
        title = "Новая категория"
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
            string: "Введите название категории",
            attributes: [
                .foregroundColor: UIColor(resource: .grayStatic),
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        textField.attributedPlaceholder = placeholder
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        [textField, textFieldContainer, doneButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            textFieldContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldContainer.heightAnchor.constraint(equalToConstant: 75),
            
            textField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -41),
            textField.centerYAnchor.constraint(equalTo: textFieldContainer.centerYAnchor),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func doneButtonTapped() {

    }
    
    @objc private func textDidChange() {
        updateCreateButtonState()
    }
    
    // MARK: - UpdateCreateButtonState
    
    private func updateCreateButtonState() {
        let text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? "" // берем текст из поля, убираем по бокам пробелы и переносы
        let isFormValid = !text.isEmpty
        
        doneButton.isEnabled = isFormValid
        
        if isFormValid {
            doneButton.backgroundColor = .blackYP
            doneButton.setTitleColor(.whiteYP, for: .normal)
        } else {
            doneButton.backgroundColor = .grayStatic
            doneButton.setTitleColor(.whiteStatic, for: .normal)
        }
    }
}
