//
//  DetailCardView.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import UIKit

class DetailCardView: UIView {
    
    var date: Date?
    var text: String?
    var elevation: Float?
    var temp: Float?
    var dewpoint: Float?
    var pressureHg: Float?
    var pressureHpa: Double?
    var humidity: Float?

    private let frameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(date: Date?, text: String?, elevation: Float?, temp: Float?, dewpoint: Float?, pressureHg: Float?, pressureHpa: Double?, humidity: Float?) {
        self.date = date
        self.text = text
        self.elevation = elevation
        self.temp = temp
        self.dewpoint = dewpoint
        self.pressureHg = pressureHg
        self.pressureHpa = pressureHpa
        self.humidity = humidity

        super.init(frame: .zero)
        setupView()
        layoutView()
        updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {

    }

    private func layoutView() {
        self.addSubview(frameView)
        self.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),

            frameView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            frameView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            frameView.topAnchor.constraint(equalTo: self.topAnchor),
            frameView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

    }

    private func updateView() {
        stackView.removeAllArrangedViews()

        if let date {
            stackView.addArrangedSubview(DetailLabel(name: "Date", value: date.formatted(date: .complete, time: .standard)))
        }
        if let text {
            stackView.addArrangedSubview(DetailLabel(name: "Text", value: text))
        }
        if let elevation {
            stackView.addArrangedSubview(DetailLabel(name: "Elevation", value: "\(elevation)", units: "ft"))
        }
        if let temp {
            stackView.addArrangedSubview(DetailLabel(name: "Temp", value: "\(temp)", units: "C"))
        }
        if let dewpoint {
            stackView.addArrangedSubview(DetailLabel(name: "Dewpoint", value: "\(dewpoint)", units: "C"))
        }
        if let pressureHg {
            stackView.addArrangedSubview(DetailLabel(name: "Pressure HG", value: "\(pressureHg)", units: "inHg"))
        }
        if let pressureHpa {
            stackView.addArrangedSubview(DetailLabel(name: "Pressure HPA", value: "\(pressureHpa)", units: "hPa"))
        }
        if let humidity {
            stackView.addArrangedSubview(DetailLabel(name: "Relative Humidity", value: "\(humidity)", units: "%"))
        }
    }

    func configureView(date: Date?, text: String?, elevation: Float?, temp: Float?, dewpoint: Float?, pressureHg: Float?, pressureHpa: Double?, humidity: Float?) {
        self.date = date
        self.text = text
        self.elevation = elevation
        self.temp = temp
        self.dewpoint = dewpoint
        self.pressureHg = pressureHg
        self.pressureHpa = pressureHpa
        self.humidity = humidity

        updateView()
    }
}
