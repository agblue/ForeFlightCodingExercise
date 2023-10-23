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
        // Validate the location
        guard let location = location,
              location.unicodeScalars.count == 4 else { return }

        // Call the API to retrive location
        Task {
            if let report = await DataManager().getReportFor(location: location) {
                print("PRINT: Report downloaded: \(report.report.conditions.text)")

                // Save retrieved information to CoreData
            }

            print("PRINT: Report Download Failed")
            // Handle Errors
        }
    }
}
