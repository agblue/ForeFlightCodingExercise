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
        layoutView()
        updateView()
    }

    // MARK: - Private Functions
    private func setupView() {
        view.backgroundColor = .white
    }

    private func layoutView() {

    }

    // MARK: - Public Functions
    func updateView() {
        if let location = viewModel.location {
            self.title = location
        } else {
            self.title = "Select Location"
        }


    }
}
