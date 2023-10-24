//
//  Locations.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

class Locations {
    var recentLocations: [String] {
        didSet {
            saveLocations()
        }
    }

    init() {
        if let recentData = UserDefaults.standard.data(forKey: "recentLocations") {
            let decoder = JSONDecoder()
            if let locations = try? decoder.decode([String].self, from: recentData) {
                recentLocations = locations
                return

            }
        }
        // Default recent locations to blank
        recentLocations = []
    }

    func saveLocations() {
        // Save the recent locations list to UserDefaults
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(recentLocations)
            UserDefaults.standard.setValue(data, forKey: "recentLocations")
        } catch {
            // Unable to encode data.
        }
    }

    func addLocation(_ location: String) {
        // Check if the location already exists, if so remove it and then insert the location at the beginning of the list.
        recentLocations.removeAll { element in
            element == location
        }
        recentLocations.insert(location, at: 0)
    }

    func removeLocation(at index: Int) {
        recentLocations.remove(at: index)
    }
}
