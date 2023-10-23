//
//  AddLocationViewModel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import CoreData
import Foundation

protocol AddLocationViewModelDelegate: AddLocationViewController {
    func addLocation(success: Bool)
}

class AddLocationViewModel {

    weak var delegate: AddLocationViewModelDelegate?
    var location: String?

    init(location: String?) {
        self.location = location
    }

    func addLocation(_ location: String?) {
        // Validate the location
        guard let location = location,
              location.unicodeScalars.count == 4 else { return }

        // Call the API to retrive location
        self.location = location
        Task {
            let result = await DataManager().getReportFor(location: location)
            print("PRINT: Report downloaded result: \(result)")
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.addLocation(success: result)
            }
        }
    }
}
