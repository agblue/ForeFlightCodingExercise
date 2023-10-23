//
//  MainViewModel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

protocol MainViewModelDelegate: MainViewController {
    func refreshView()
    func addLocation()
    func showLocation(location: String)
}

class MainViewModel {

    var locations: [String]

    weak var delegate: MainViewModelDelegate?

    init(delegate: MainViewModelDelegate?) {
        self.delegate = delegate

        locations = ["KHOU", "KPWM", "KAUS"]
    }

    func showAddLocation() {
        print("PRINT: Show the Add Location Modal and capture the returned location.")
        self.delegate?.addLocation()
    }

    func selectLocation(at index: Int) {
        guard index < locations.count else { return }

        let location = locations[index]
        self.delegate?.showLocation(location: location)
    }



    func addLocation(_ location: String) {
        locations.insert(location, at: 0)
    }
}
