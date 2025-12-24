import UIKit

final class CategoryListCell: UITableViewCell {
    // MARK: - Static Properties
    
    static let reuseIdentifier = "CategoryListCell"
    
    // MARK: - Private Properties
    
    private let categoryLabel = UILabel()
    private let separatorView = UIView()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with title: String) {
        categoryLabel.text = title
    }
    
    func setSeparatorVisible(_ isVisible: Bool) {
        separatorView.isHidden = !isVisible
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.addSubviews([categoryLabel, separatorView])
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        categoryLabel.font = .systemFont(ofSize: 17, weight: .regular)
        categoryLabel.textColor = .blackYP
        categoryLabel.textAlignment = .left
        
        separatorView.backgroundColor = .grayStatic
    }
    
    private func setupLayout() {
        [categoryLabel, separatorView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
