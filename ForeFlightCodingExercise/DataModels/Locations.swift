//
//  Locations.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

protocol LocationsDelegate: AnyObject {
    func locationsUpdated()
}

class Locations {
    
    // MARK: - Public Properties
    weak var delegate: LocationsDelegate?
    var count: Int {
        return recentLocations.count
    }
    var locations: [String] {
        return recentLocations
    }

    // MARK: - Private Properties
    private var recentLocations: [String] {
        didSet {
            saveLocations()
        }
    }

    // MARK: - Lifecycle Functions
    init(delegate: LocationsDelegate?) {
        self.delegate = delegate

        // Load the recentlocations from UserDefaults.
        if let recentData = UserDefaults.standard.data(forKey: "recentLocations") {
            let decoder = JSONDecoder()
            if let locations = try? decoder.decode([String].self, from: recentData) {
                recentLocations = locations
                return
            }
        }
        
        // If key doesn't exist then load the default locations.
        recentLocations = []
        addLocation("KPWM")
        addLocation("KAUS")
    }

    // MARK: - Private Functions
    private func saveLocations() {
        // Save the recent locations list to UserDefaults
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(recentLocations) {
            UserDefaults.standard.setValue(data, forKey: "recentLocations")
        }
    }

    // MARK: - Public Functions
    func at(_ index: Int) -> String? {
        guard index < recentLocations.count else { return nil }
        return recentLocations[index]
    }

    func addLocation(_ location: String) {
        let location = location.uppercased()
        // Check if the location already exists, if so remove it and then insert the location at the beginning of the list.
        recentLocations.removeAll { element in
            element.uppercased() == location
        }
        recentLocations.insert(location, at: 0)
    }

    func removeLocation(at index: Int) {
        recentLocations.remove(at: index)
    }
}
