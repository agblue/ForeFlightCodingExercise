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
    let detailsSegmentedControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.insertSegment(withTitle: "Conditions", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "Forecast", at: 1, animated: false)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()

    var conditionsCard: DetailCardView = {
        let view = DetailCardView(date: nil, text: nil, elevation: nil, temp: nil, dewpoint: nil, pressureHg: nil, pressureHpa: nil, humidity: nil)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
//        updateView()
    }

    // MARK: - Private Functions
    private func setupView() {
        view.backgroundColor = Constants.backgroundColor
        viewModel.delegate = self
    }

    private func setupButtons() {
        detailsSegmentedControl.addTarget(self, action: #selector(segmentSelected), for: .valueChanged)
    }

    private func layoutView() {
        view.addSubview(detailsSegmentedControl)
        view.addSubview(conditionsCard)

        NSLayoutConstraint.activate([
            detailsSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            detailsSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
            detailsSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            conditionsCard.leadingAnchor.constraint(equalTo: detailsSegmentedControl.leadingAnchor),
            conditionsCard.trailingAnchor.constraint(equalTo: detailsSegmentedControl.trailingAnchor),
            conditionsCard.topAnchor.constraint(equalTo: detailsSegmentedControl.bottomAnchor, constant: 20),
            conditionsCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }

    @objc private func segmentSelected(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        viewModel.selectedDetailIndex = index
    }

    // MARK: - Public Functions
    func updateView() {
        if let location = viewModel.location {
            self.title = location
        } else {
            self.title = "Select Location"
        }

        detailsSegmentedControl.selectedSegmentIndex = viewModel.selectedDetailIndex

        if viewModel.selectedDetailIndex == 0 {
            // Show Conditions Card
            if let conditions = viewModel.conditions {
                conditionsCard.configureView(date: conditions.dateIssued,
                                             text: conditions.text,
                                             elevation: conditions.elevationFt,
                                             temp: conditions.tempC,
                                             dewpoint: conditions.dewpointC,
                                             pressureHg: conditions.pressureHg,
                                             pressureHpa: conditions.pressureHpa,
                                             humidity: conditions.relativeHumidity)
                conditionsCard.isHidden = false
            }
        } else {
            // Show Forecast Card
        }
    }
}

extension LocationDetailViewController: LocationDetailViewModelProtocol {
    func refreshView() {
        updateView()
    }
}
