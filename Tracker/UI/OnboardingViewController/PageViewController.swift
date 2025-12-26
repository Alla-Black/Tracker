import UIKit

final class PageViewController: UIViewController {
    private let image: UIImage
    private let text: String
    
    let imageView = UIImageView()
    let label = UILabel()
    
    init(
        image: UIImage,
        text: String
    ) {
        self.image = image
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        label.text = text
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .blackStatic
        label.textAlignment = .center
        label.numberOfLines = 0
        
        let contentView = UIView()
        
        view.addSubview(imageView)
        view.addSubview(contentView)
        contentView.addSubview(label)
        
        [contentView, imageView, label].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -140),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -130)
            ])
    }
}
