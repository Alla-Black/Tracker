import UIKit

final class TrackerSectionHeaderView: UICollectionReusableView {
    
    // MARK: - Static Properties
    
    static let identifier = "TrackerSectionHeader"
    
    // MARK: - Private Properties
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .blackYP
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(categoryLabel)
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with title: String) {
        categoryLabel.text = title
    }
}
