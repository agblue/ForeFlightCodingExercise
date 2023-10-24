//
//  MainViewModel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

protocol MainViewModelDelegate: MainViewController {
    func refreshView()
    func showLocation(location: String)
}

class MainViewModel {

    var locations = Locations()

    weak var delegate: MainViewModelDelegate?

    init(delegate: MainViewModelDelegate?) {
        self.delegate = delegate
    }

    func selectLocation(at index: Int) {
        guard index < locations.recentLocations.count else { return }
        let location = locations.recentLocations[index]
        self.delegate?.showLocation(location: location)
    }

    func addLocation(_ location: String) {
        locations.addLocation(location)
    }
}
