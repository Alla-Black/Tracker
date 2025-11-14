import UIKit

final class DatePickerView: UIView {
    // MARK: - Private Properties
    
    private let dateContainer = UIView()
    private let datePicker = UIDatePicker()
    private let dateLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        
        //MARK: - Add Subviews
        
        addSubview(dateContainer)
        dateContainer.addSubview(datePicker)
        dateContainer.addSubview(dateLabel)
        
        //MARK: - Configure Appearance
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.alpha = 0.02
        datePicker.setContentHuggingPriority(.defaultLow, for: .horizontal)
        datePicker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        dateLabel.text = DateFormatterHelper.dateFormatter.string(from: datePicker.date)
        dateLabel.textColor = UIColor(resource: .blackYP).resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        dateLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        dateContainer.backgroundColor = UIColor(red: 0xF0/255.0, green: 0xF0/255.0, blue: 0xF0/255.0, alpha: 1)
        dateContainer.layer.cornerRadius = 8
        
        // MARK: - Constraints
        
        [dateContainer, dateLabel, datePicker].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            dateContainer.heightAnchor.constraint(equalToConstant: 34),
            dateContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 77),
            dateContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateContainer.topAnchor.constraint(equalTo: topAnchor),
            dateContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            datePicker.leadingAnchor.constraint(equalTo: dateContainer.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: dateContainer.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: dateContainer.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: dateContainer.bottomAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: dateContainer.leadingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: dateContainer.trailingAnchor, constant: -12),
            dateLabel.topAnchor.constraint(equalTo: dateContainer.topAnchor, constant: 6),
            dateLabel.bottomAnchor.constraint(equalTo: dateContainer.bottomAnchor, constant: -6)
        ])
    }
    
    // MARK: - Actions
    private func setupActions() {
        datePicker.addTarget(
            self,
            action: #selector(dateChanged),
            for: .valueChanged
        )
    }
    
    @objc private func dateChanged() {
        dateLabel.text = DateFormatterHelper.dateFormatter.string(from: datePicker.date)
    }
}

