import UIKit

final class TrackerSettingsCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "trackerSettingsCell"
    
    // MARK: - Private Properties
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let separatorView = UIView()
    private let textStack = UIStackView()
    
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
    
    func setSubtitle(_ text: String?) {
        subtitleLabel.text = text
        subtitleLabel.isHidden = (text == nil || text?.isEmpty == true)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.addSubviews([textStack, arrowImageView, separatorView])
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 2
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .blackYP
        titleLabel.textAlignment = .left
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = .grayStatic
        subtitleLabel.textAlignment = .left
        subtitleLabel.isHidden = true
        
        arrowImageView.image = .arrow
        
        separatorView.backgroundColor = .grayStatic
        
    }
    
    private func setupLayout() {
        [textStack, arrowImageView, separatorView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: textStack.centerYAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
