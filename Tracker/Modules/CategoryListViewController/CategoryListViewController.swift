import UIKit

final class CategoryListViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var stubImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .trackersPlaceholder)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно \n объединить по смыслу"
        label.textColor = UIColor(resource: .blackYP)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private lazy var stubStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackYP
        button.layer.cornerRadius = 16
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.whiteYP, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(
            self,
            action: #selector(addCategoryButtonTapped),
            for: .touchUpInside
            )
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureAppearance()
        setupConstraints()
        setStub()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.addSubviews([stubStack, addCategoryButton])
        stubStack.addArrangedSubview(stubImage)
        stubStack.addArrangedSubview(stubLabel)
    }
    
    private func configureAppearance() {
        view.backgroundColor = .whiteYP
        
        // NavBar Title
        title = "Категория"
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
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
    }
    
    private func setupConstraints() {
        [stubStack, stubImage, stubLabel, addCategoryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            
            stubStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stubStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setStub() {
        
    }
    
    @objc
    private func addCategoryButtonTapped() {
        
    }
}

#Preview {
    UINavigationController(rootViewController: CategoryListViewController())
}
