import UIKit

final class EmojiColorViewCell: UICollectionViewCell {

    // MARK: - Static Properties
    
    static let identifier = "emojiColorCell"
    
    // MARK: - Private Properties
    
    private let emojiLabel = UILabel()
    private let colorView = UIView()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews([emojiLabel, colorView])
        [emojiLabel, colorView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        emojiLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        emojiLabel.textAlignment = .center
        
        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        emojiLabel.text = nil
        emojiLabel.isHidden = false
        colorView.isHidden = true
        
        colorView.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 0
        contentView.layer.masksToBounds = false
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = nil
    }
    
    func configureAsEmoji(_ emoji: String, isSelected: Bool) {
        emojiLabel.isHidden = false
        colorView.isHidden = true
        emojiLabel.text = emoji
        
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = nil
        
        if isSelected {
            contentView.layer.cornerRadius = 16
            contentView.layer.masksToBounds = true
            contentView.backgroundColor = .lightGrayStatic
            
        } else {
            contentView.layer.cornerRadius = 0
            contentView.layer.masksToBounds = false
            contentView.backgroundColor = .clear
        }
    }
    
    func configureAsColor(_ color: UIColor, isSelected: Bool) {
        emojiLabel.isHidden = true
        colorView.isHidden = false
        colorView.backgroundColor = color
        
        contentView.backgroundColor = .clear
        
        if isSelected {
            contentView.layer.borderWidth = 3
            contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
            contentView.layer.cornerRadius = 8
            contentView.layer.masksToBounds = true
        } else {
            contentView.layer.borderWidth = 0
            contentView.layer.borderColor = nil
            contentView.layer.cornerRadius = 0
            contentView.layer.masksToBounds = false
        }
        
    }
}
