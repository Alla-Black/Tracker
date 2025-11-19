import UIKit

// TODO: protocol TrackerCellDelegate: AnyObject {
// func trackerCellDidTapPlus(_ cell: TrackerCollectionViewCell) }


// MARK: - TrackerCollectionViewCell

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private let topContainerView = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    
    private let bottomContainerView = UIView()
    private let daysCountLabel = UILabel()
    private let plusButton = UIButton()
    
    // TODO: private weak var delegate: TrackerCellDelegate?
    
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
    
    // MARK: - Private Methods
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.addSubview(topContainerView)
        topContainerView.addSubviews([emojiLabel, titleLabel])
        
        contentView.addSubview(bottomContainerView)
        bottomContainerView.addSubviews([daysCountLabel, plusButton])
        
        topContainerView.layer.cornerRadius = 16
        topContainerView.layer.borderWidth = 1
        topContainerView.layer.borderColor = UIColor.grayYP.withAlphaComponent(0.3).cgColor
        topContainerView.clipsToBounds = true
        
        
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.clipsToBounds = true
        emojiLabel.backgroundColor = .whiteYP.withAlphaComponent(0.3)
        emojiLabel.textAlignment = .center
        
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .whiteYP
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        
        daysCountLabel.font = .systemFont(ofSize: 12, weight: .medium)
        daysCountLabel.textColor = .blackYP
        daysCountLabel.textAlignment = .left
        
        plusButton.setImage(
            UIImage(systemName: "plus"),
            for: .normal
        )
        plusButton.imageView?.contentMode = .center
        plusButton.tintColor = .whiteYP
        plusButton.layer.cornerRadius = 17
        plusButton.clipsToBounds = true
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        [topContainerView, bottomContainerView, emojiLabel, titleLabel, daysCountLabel, plusButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: emojiLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -12),
            
            bottomContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            bottomContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -12),
            
            daysCountLabel.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            daysCountLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 12),
            daysCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: plusButton.leadingAnchor, constant: -8)
        ])
    }
    
    // MARK: - Setup Actions
    
    private func setupActions() {
        plusButton.addTarget(
            self,
            action: #selector(didTapPlusButton),
            for: .touchUpInside
        )
    }
    
    @objc private func didTapPlusButton() {
    // TODO: тут должен быть делегат delegate?.trackerCellDidTapPlus(self)
    }
    
    
}
