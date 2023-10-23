//
//  AddLocationViewModel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

class AddLocationViewModel {

    var location: String?

    init(location: String?) {
        self.location = location
    }

    func addLocation(_ location: String?) {
        guard location?.unicodeScalars.count == 4 else { return }
        // Validate the location
        // Call the API to retrive location
        // Save retrieved information to CoreData
        // Handle Errors
    }
}
