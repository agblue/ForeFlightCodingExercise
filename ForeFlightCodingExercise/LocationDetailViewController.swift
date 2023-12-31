//
//  LocationDetailViewController.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import UIKit

class LocationDetailViewController: UIViewController {

    // MARK: - Private Properties
    private let viewModel: LocationDetailViewModel

    // MARK: - UI Elements
    private let refreshButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .refresh)
        return button
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let detailsSegmentedControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.insertSegment(withTitle: "Conditions", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "Forecast", at: 1, animated: false)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()

    private let toggleLabel: UILabel = {
        let label = UILabel()
        label.text = "Auto Refresh"
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    private let cardsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Lifecycle Functions
    init(viewModel: LocationDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupButtons()
        layoutView()
        viewModel.loadData()
    }

    // MARK: - Private Functions
    private func setupView() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        viewModel.delegate = self
    }

    private func setupButtons() {
        refreshButton.target = self
        refreshButton.action = #selector(refreshButtonTapped)
        self.navigationItem.rightBarButtonItem = refreshButton

        detailsSegmentedControl.addTarget(self, action: #selector(segmentSelected), for: .valueChanged)
        toggleSwitch.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
    }

    private func layoutView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(detailsSegmentedControl)
        contentView.addSubview(toggleLabel)
        contentView.addSubview(toggleSwitch)
        contentView.addSubview(cardsStack)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            detailsSegmentedControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            detailsSegmentedControl.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            detailsSegmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),

            toggleSwitch.trailingAnchor.constraint(equalTo: detailsSegmentedControl.trailingAnchor),
            toggleSwitch.topAnchor.constraint(equalTo: detailsSegmentedControl.bottomAnchor, constant: 20),

            toggleLabel.centerYAnchor.constraint(equalTo: toggleSwitch.centerYAnchor),
            toggleLabel.trailingAnchor.constraint(equalTo: toggleSwitch.leadingAnchor, constant: -10),

            cardsStack.leadingAnchor.constraint(equalTo: detailsSegmentedControl.leadingAnchor),
            cardsStack.trailingAnchor.constraint(equalTo: detailsSegmentedControl.trailingAnchor),
            cardsStack.topAnchor.constraint(equalTo: toggleSwitch.bottomAnchor, constant: 20),
            cardsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    @objc private func segmentSelected(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        viewModel.selectedDetailIndex = index
        updateView()
    }

    @objc private func toggleChanged(sender: UISwitch) {
        viewModel.autoRefresh = sender.isOn
    }

    @objc private func refreshButtonTapped() {
        viewModel.fetchData()
    }

    private func updateView() {
        if let location = viewModel.location {
            self.title = location
        } else {
            self.title = "Select A Location"
        }

        detailsSegmentedControl.selectedSegmentIndex = viewModel.selectedDetailIndex

        toggleSwitch.isOn = viewModel.autoRefresh

        cardsStack.removeAllArrangedViews()
        if viewModel.selectedDetailIndex == 0 {
            // Show Conditions Card
            if let conditions = viewModel.conditions {
                let conditionsCard = DetailCardView(date: conditions.dateIssued,
                                             text: conditions.text,
                                             elevation: conditions.elevationFt,
                                             temp: conditions.tempC,
                                             dewpoint: conditions.dewpointC,
                                             pressureHg: conditions.pressureHg,
                                             pressureHpa: conditions.pressureHpa,
                                             humidity: conditions.relativeHumidity)
                cardsStack.addArrangedSubview(conditionsCard)

            }
        } else {
            // Show Forecast Cards
            if let forecast = viewModel.forecast {
                let forecastCard = DetailCardView(date: forecast.dateIssued,
                                                  text: forecast.text,
                                                  elevation: forecast.elevationFt,
                                                  temp: nil,
                                                  dewpoint: nil,
                                                  pressureHg: nil,
                                                  pressureHpa: nil,
                                                  humidity: nil)
                cardsStack.addArrangedSubview(forecastCard)

                if let conditions = forecast.conditions?.allObjects as? [ForecastConditionEntity] {
                    let conditionsSorted = conditions.sorted { elementA, elementB in
                        guard let dateA = elementA.dateIssued else { return false }
                        guard let dateB = elementB.dateIssued else { return true }
                        return dateA < dateB
                    }

                    for condition in conditionsSorted {
                        let conditionsCard = DetailCardView(date: condition.dateIssued,
                                                            text: condition.text,
                                                            elevation: condition.elevationFt,
                                                            temp: nil,
                                                            dewpoint: nil,
                                                            pressureHg: nil,
                                                            pressureHpa: nil,
                                                            humidity: condition.relativeHumidity)
                        cardsStack.addArrangedSubview(conditionsCard)
                    }
                }
            }
        }
    }

    // MARK: - Public Functions
    func updateLocation(_ location: String?) {
        viewModel.location = location
        viewModel.startTimer()
        viewModel.loadData()
    }
}

extension LocationDetailViewController: LocationDetailViewModelProtocol {
    func refreshView() {
        updateView()
    }
}
