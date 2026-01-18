import UIKit

final class StatisticsCell: UITableViewCell {
    
    static let reuseIdentifier = "StatisticsCell"
    
    // MARK: - Private Properties
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackYP
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackYP
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with item: StatisticsItem) {
        valueLabel.text = "\(item.value)"
        titleLabel.text = item.title
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(cardView)
        cardView.addSubview(valueLabel)
        cardView.addSubview(titleLabel)
        
        cardView.layer.addSublayer(gradientLayer)
        setupGradient()
    }
    
    private func setupConstraints() {
        [cardView, valueLabel, titleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(resource: .redGradient).cgColor,
            UIColor(resource: .greenGradient).cgColor,
            UIColor(resource: .blueGradient).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1
        
        gradientLayer.mask = shapeLayer
    }
    
    // MARK: - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueLabel.text = nil
        titleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = cardView.bounds
        
        let inset = shapeLayer.lineWidth / 2
        let rect = cardView.bounds.insetBy(dx: inset, dy: inset)
        let radius = cardView.layer.cornerRadius - inset
        let path = UIBezierPath(
            roundedRect: rect,
            cornerRadius: max(0, radius)
        )
        
        shapeLayer.path = path.cgPath
    }
}

