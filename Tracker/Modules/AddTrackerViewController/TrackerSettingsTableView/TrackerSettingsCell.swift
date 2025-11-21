import UIKit

final class TrackerSettingsCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "trackerSettingsCell"
    
    // MARK: - Private Properties
    
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let separatorView = UIView()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    func setSeparatorVisible(_ isVisible: Bool) {
        separatorView.isHidden = !isVisible
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.addSubviews([titleLabel, arrowImageView, separatorView])
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .blackYP
        titleLabel.textAlignment = .left
        
        arrowImageView.image = .arrow
        
        separatorView.backgroundColor = .grayStatic
        
    }
    
    private func setupLayout() {
        [titleLabel, arrowImageView, separatorView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
