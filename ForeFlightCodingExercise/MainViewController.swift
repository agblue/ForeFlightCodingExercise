//
//  MainViewController.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Private Properties
    private let viewModel: MainViewModel

    // MARK: - UI Elemenets
    private let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        return button
    }()

    private let locationsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle Functions
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupButtons()
        layoutView()
        updateView()
    }

    // MARK: - Private Functions
    private func setupView() {
        title = "ForeFlight Weather"
        view.backgroundColor = .white

        self.viewModel.delegate = self

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

    @objc private func addButtonTapped() {
        showAddLocation()
    }

    // MARK: - Public Functions
    func updateView() {
        locationsTableView.reloadData()
    }

    func showAddLocation() {
        let addLocationViewModel = AddLocationViewModel(dataManager: viewModel.dataManager)
        let addLocationViewController = AddLocationViewController(delegate: self, viewModel: addLocationViewModel)
        let navigationController = UINavigationController()
        navigationController.pushViewController(addLocationViewController, animated: false)
        present(navigationController, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locationData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? UITableViewCell else { return UITableViewCell() }

        let location = viewModel.locationData.at(indexPath.row)
        cell.textLabel?.text = location
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectLocation(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeLocation(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - MainViewModelDelegate
extension MainViewController: MainViewModelDelegate {
    func refreshView() {
        updateView()
    }

    func showLocation(location: String) {
        guard let locationViewController = splitViewController?.viewController(for: .secondary) as? LocationDetailViewController else { return }
        locationViewController.updateLocation(location)
        splitViewController?.showDetailViewController(locationViewController, sender: self)
    }
}

// MARK: - AddLocationViewControllerDelegate
extension MainViewController: AddLocationViewControllerDelegate {
    func didCancel() {
        // Cancel AddLocation was tapped.
    }
    
    func didAddLocation(_ location: String) {
        // Add the new location to the recents list.
        viewModel.addLocation(location)

        // Select the location in the details view.
        locationsTableView.reloadData()
        locationsTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        showLocation(location: location)
    }
}
