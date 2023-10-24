//
//  AddLocationViewModel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import CoreData
import Foundation

protocol AddLocationViewModelDelegate: AddLocationViewController {
    func refreshView()
    func addLocation(success: Bool)
}

class AddLocationViewModel {

    var dataManager: DataManager
    weak var delegate: AddLocationViewModelDelegate?
    var location: String?
    var isLoading: Bool = false {
        didSet {
            delegate?.refreshView()
        }
    }

    init(dataManager: DataManager, location: String? = nil, delegate: AddLocationViewModelDelegate? = nil) {
        self.dataManager = dataManager
        self.location = location
        self.delegate = delegate
    }

    func addLocation(_ location: String?) {
        // Validate the location
        guard let location = location,
              location.unicodeScalars.count == 4 else { return }

        isLoading = true
        // Call the API to retrive location
        self.location = location
        Task {
            let result = await dataManager.getReportFor(location: location)
            print("PRINT: Report downloaded result: \(result)")
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                self?.delegate?.addLocation(success: result)
            }
        }
    }
}
