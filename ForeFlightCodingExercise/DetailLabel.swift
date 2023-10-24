//
//  DetailLabel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import UIKit

class DetailLabel: UIView {
    // MARK: - Public Properties
    var name: String
    var value: String
    var units: String

    // MARK: - UI Elements
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle Functions
    init(name: String, value: String, units: String? = nil) {
        self.name = name
        self.value = value
        self.units = units ?? ""
        super.init(frame: .zero)

        layoutView()
        updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    private func layoutView() {
        self.addSubview(nameLabel)
        self.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            valueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 20),
            valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }

    private func updateView() {
        nameLabel.text = name
        valueLabel.text = "\(value) \(units)".trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Public Functions
    func configureView(name: String, value: String, units: String? = nil) {
        self.name = name
        self.value = value
        self.units = units ?? ""
        updateView()
    }

}
