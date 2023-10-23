//
//  MainViewController.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import UIKit

class MainViewController: UIViewController, MainViewModelProtocol {

    // MARK: - Private Properties
    private let viewModel = MainViewModel()

    // MARK: - UI Elemenets
    private let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        return button
    }()

    private let locationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupButtons()
        layoutView()
        updateView()
    }

    private func setupView() {
        title = "ForeFlight Weather"
        view.backgroundColor = .white

        locationsTableView.delegate = self
        locationsTableView.dataSource = self
    }

    private func setupButtons() {
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        self.navigationItem.rightBarButtonItem = addButton
    }

    private func layoutView() {
        view.addSubview(locationsTableView)

        NSLayoutConstraint.activate([
            locationsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            locationsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            locationsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Private Functions
    @objc private func addButtonTapped() {
        viewModel.showAddLocation()
    }

    // MARK: - Public Functions
    func updateView() {
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? UITableViewCell else { return UITableViewCell() }

        let location = viewModel.locations[indexPath.row]
        cell.textLabel?.text = location
        return cell
    }
}
