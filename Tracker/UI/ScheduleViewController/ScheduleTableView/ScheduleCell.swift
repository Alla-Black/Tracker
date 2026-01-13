import UIKit

final class ScheduleCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "scheduleCell"
    
    // MARK: - Public Properties
    
    var onSwitchChanged: ((Bool) -> Void)?
    
    // MARK: - Private Properties
    
    private let titleLabel = UILabel()
    
    private let toggleSwitch  = UISwitch()
    private let separatorView = UIView()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupUI()
        setupLayout()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with title: String, isOn: Bool) {
        titleLabel.text = title
        toggleSwitch.isOn = isOn
    }
    
    func setSeparatorVisible(_ isVisible: Bool) {
        separatorView.isHidden = !isVisible
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.addSubviews([titleLabel, toggleSwitch, separatorView])
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .blackYP
        titleLabel.textAlignment = .left
    
        toggleSwitch.onTintColor = .blueStatic
        
        separatorView.backgroundColor = .grayStatic
        
    }
    
    private func setupLayout() {
        [titleLabel, toggleSwitch, separatorView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: toggleSwitch.leadingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupAction() {
        toggleSwitch.addTarget(
            self,
            action: #selector(switchChanged),
            for: .valueChanged
        )
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        onSwitchChanged?(sender.isOn)
    }
}
