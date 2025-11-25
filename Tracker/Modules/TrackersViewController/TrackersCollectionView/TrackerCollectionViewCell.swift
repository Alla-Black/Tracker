import UIKit

// MARK: - TrackerCellDelegate Protocol

protocol TrackerCellDelegate: AnyObject {
    func trackerCellDidTapPlus(_ cell: TrackerCollectionViewCell)
}


// MARK: - TrackerCollectionViewCell

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let identifier = "trackerCell"
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - Private Properties
    
    private let topContainerView = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    
    private let bottomContainerView = UIView()
    private let daysCountLabel = UILabel()
    private let completeButton = UIButton()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    // MARK: - Configure
    
    func configure(with tracker: Tracker, days: Int, isCompleted: Bool) {
        emojiLabel.text = tracker.emoji
        
        titleLabel.text = tracker.name
        
        topContainerView.backgroundColor = tracker.color
        completeButton.backgroundColor = tracker.color
        
        daysCountLabel.text = makeDaysText(from: days)
        updateCompleteButton(isCompleted: isCompleted)
    }
    
    // MARK: - Private Methods
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.addSubview(topContainerView)
        topContainerView.addSubviews([emojiLabel, titleLabel])
        
        contentView.addSubview(bottomContainerView)
        bottomContainerView.addSubviews([daysCountLabel, completeButton])
        
        topContainerView.layer.cornerRadius = 16
        topContainerView.layer.borderWidth = 1
        topContainerView.layer.borderColor = UIColor.grayStatic.withAlphaComponent(0.3).cgColor
        topContainerView.clipsToBounds = true
        
        
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.clipsToBounds = true
        emojiLabel.backgroundColor = .whiteStatic.withAlphaComponent(0.3)
        emojiLabel.textAlignment = .center
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .whiteStatic
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        
        daysCountLabel.font = .systemFont(ofSize: 12, weight: .medium)
        daysCountLabel.textColor = .blackYP
        daysCountLabel.textAlignment = .left
        
        completeButton.imageView?.contentMode = .center
        completeButton.tintColor = .whiteYP
        completeButton.layer.cornerRadius = 17
        completeButton.clipsToBounds = true
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        [topContainerView, bottomContainerView, emojiLabel, titleLabel, daysCountLabel, completeButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topContainerView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            topContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 90.0 / 148.0),
            
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 12),
            
            titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -12),
            
            bottomContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            bottomContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            completeButton.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -12),
            
            daysCountLabel.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            daysCountLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 12),
            daysCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: completeButton.leadingAnchor, constant: -8)
        ])
    }
    
    // MARK: - Setup Actions
    
    private func setupActions() {
        completeButton.addTarget(
            self,
            action: #selector(didTapPlusButton),
            for: .touchUpInside
        )
    }
    
    @objc private func didTapPlusButton() {
        delegate?.trackerCellDidTapPlus(self)
    }
    
    // MARK: - UpdateCompleteButton
    
    private func updateCompleteButton(isCompleted: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        
        if isCompleted {
            let checkImage = UIImage(
                systemName: "checkmark",
                withConfiguration: config
            )
            completeButton.setImage(checkImage, for: .normal)
            completeButton.alpha = 0.3
        } else {
            let plusImage = UIImage(
                systemName: "plus",
                withConfiguration: config
            )
            completeButton.setImage(plusImage, for: .normal)
            completeButton.alpha = 1
        }
    }
    
    // MARK: - Declension of the counter days
    
    private func makeDaysText(from count: Int) -> String {
        let lastTwo = count % 100
        let last = count % 10
        
        let word: String
        if lastTwo >= 11 && lastTwo <= 14 {
            word = "дней"
        } else if last == 1 {
            word = "день"
        } else if last >= 2 && last <= 4 {
            word = "дня"
        } else {
            word = "дней"
        }
        
        return "\(count) \(word)"
    }
    
    
}
