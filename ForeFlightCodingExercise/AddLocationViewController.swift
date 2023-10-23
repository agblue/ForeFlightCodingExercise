//
//  AddLocationViewController.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import UIKit

protocol AddLocationViewControllerDelegate: AnyObject {
    func didCancel()
    func didAddLocation(_ location: String)
}

class AddLocationViewController: UIViewController {
    static let maxLocationLength = 4

    // MARK: - Public properties
    weak var delegate: AddLocationViewControllerDelegate?

    // MARK: - Private Properties
    private let viewModel: AddLocationViewModel = AddLocationViewModel(location: nil)

    // MARK: - UI Elements
    private let cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .cancel)
        return button
    }()

    private let addLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.text = "Enter the airport identifer to add. (ex: KHOU)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.autocapitalizationType = .allCharacters
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let addButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .blue
        config.cornerStyle = .capsule
        config.title = "Add Location"

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupButtons()
        layoutView()
        updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTextField.becomeFirstResponder()
    }

    private func setupView() {
        title = "Add Airport Location"
        view.backgroundColor = .white

        viewModel.delegate = self
        addTextField.delegate = self
    }

    private func setupButtons() {
        cancelButton.target = self
        cancelButton.action = #selector(cancelButtonTapped)

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    private func layoutView() {
        navigationItem.leftBarButtonItem = cancelButton
        view.addSubview(addLabel)
        view.addSubview(addTextField)
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            addLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),

            addTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTextField.topAnchor.constraint(equalTo: addLabel.bottomAnchor, constant: 20),
            addTextField.widthAnchor.constraint(equalToConstant: 400),

            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: addTextField.bottomAnchor, constant: 20),
            addButton.widthAnchor.constraint(equalTo: addTextField.widthAnchor)
        ])
    }

    private func updateView() {

    }

    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc private func addButtonTapped() {
        guard addTextField.text?.unicodeScalars.count == AddLocationViewController.maxLocationLength else {
            return
        }
        addTextField.resignFirstResponder()
        viewModel.addLocation(addTextField.text)
    }
}

extension AddLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text?.unicodeScalars.count == AddLocationViewController.maxLocationLength else {
            return false
        }
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if reason == .committed {
            viewModel.addLocation(textField.text)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let count = textField.text?.unicodeScalars.count,
              count + string.unicodeScalars.count - range.length <= AddLocationViewController.maxLocationLength else {
            return false
        }
        return true
    }
}

extension AddLocationViewController: AddLocationViewModelDelegate {
    func addLocation(success: Bool) {
        guard let location = viewModel.location else { return }
        if success {
            self.delegate?.didAddLocation(location)
            dismiss(animated: true)
            return
        }

        let alert = UIAlertController(title: "Invalid Location", message: "Unable to add the location \(location)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.addTextField.becomeFirstResponder()
        })
        present(alert, animated: true)
    }
}
