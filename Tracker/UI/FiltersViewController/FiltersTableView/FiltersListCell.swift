import UIKit

final class FiltersListCell: UITableViewCell {
    // MARK: - Static Properties
    
    static let reuseIdentifier = "FiltersListCell"
    
    // MARK: - Private Properties
    
    private let titleLabel = UILabel()
    private let separatorView = UIView()
    private let checkMarkView = UIImageView(image: UIImage(resource: .checkMark))
    
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
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    func setSeparatorVisible(_ isVisible: Bool) {
        separatorView.isHidden = !isVisible
    }
    
    func setCheckmarkVisible(_ isVisible: Bool) {
        checkMarkView.isHidden = !isVisible
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.addSubviews([titleLabel, separatorView, checkMarkView])
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .blackYP
        titleLabel.textAlignment = .left
        
        separatorView.backgroundColor = .grayStatic
        
        checkMarkView.tintColor = .blueStatic
        checkMarkView.isHidden = true
    }
    
    private func setupLayout() {
        [titleLabel, separatorView, checkMarkView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo:  checkMarkView.leadingAnchor, constant: -1),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkMarkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkMarkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkMarkView.heightAnchor.constraint(equalToConstant: 24),
            checkMarkView.widthAnchor.constraint(equalToConstant: 24),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
