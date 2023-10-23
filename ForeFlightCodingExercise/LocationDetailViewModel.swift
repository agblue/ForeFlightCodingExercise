//
//  LocationDetailViewModel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

protocol LocationDetailViewModelProtocol {
    func updateView()
}

class LocationDetailViewModel {
    
    var location: String?

    init(location: String?) {
        self.location = location
    }
}
