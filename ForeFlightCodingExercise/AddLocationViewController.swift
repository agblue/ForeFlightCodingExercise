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
    private let viewModel: AddLocationViewModel

    // MARK: - UI Elements
    private let cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .cancel)
        return button
    }()

    private let airplaneImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "airplane.departure")?.withConfiguration(UIImage.SymbolConfiguration(paletteColors: [UIColor(named: "PrimaryColor")!])))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let addLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.text = "Enter the airport identifer to add."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "(ex: KHOU)"
        textField.textAlignment = .center
        textField.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        textField.adjustsFontForContentSizeCategory = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let addButton: UIButton = {
        var attributeContainer = AttributeContainer()
        attributeContainer.font = UIFont.preferredFont(forTextStyle: .headline)

        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(named: "AccentColor")
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString("Add Location", attributes: attributeContainer)
        config.imagePlacement = .trailing
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle Functions
    init(delegate: AddLocationViewControllerDelegate? = nil, viewModel: AddLocationViewModel) {
        self.delegate = delegate
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
        view.addSubview(airplaneImageView)
        view.addSubview(addLabel)
        view.addSubview(addTextField)
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            airplaneImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            airplaneImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            airplaneImageView.heightAnchor.constraint(equalToConstant: 80),
            airplaneImageView.widthAnchor.constraint(equalToConstant: 120),

            addLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addLabel.topAnchor.constraint(equalTo: airplaneImageView.bottomAnchor, constant: 10),

            addTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTextField.topAnchor.constraint(equalTo: addLabel.bottomAnchor, constant: 20),
            addTextField.widthAnchor.constraint(equalToConstant: 400),

            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: addTextField.bottomAnchor, constant: 20),
            addButton.widthAnchor.constraint(equalTo: addTextField.widthAnchor)
        ])
    }

    private func updateView() {
        addButton.configuration?.showsActivityIndicator = viewModel.isLoading
        addButton.isEnabled = !viewModel.isLoading
    }

    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc private func addButtonTapped() {
        guard addTextField.text?.unicodeScalars.count == AddLocationViewController.maxLocationLength else {
            return
        }
        addTextField.resignFirstResponder()
        viewModel.addLocation(addTextField.text?.uppercased())
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
    func refreshView() {
        DispatchQueue.main.async { [weak self] in
            self?.updateView()
        }
    }

    func addLocation(success: Bool) {
        guard let location = viewModel.location else { return }
        if success {
            self.delegate?.didAddLocation(location)
            dismiss(animated: true)
            return
        }

        let alert = UIAlertController(title: "Invalid Location", message: "Unable to validate the location \(location).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.addTextField.becomeFirstResponder()
        })
        present(alert, animated: true)
    }
}
