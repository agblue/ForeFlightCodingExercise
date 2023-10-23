//
//  MainViewModel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

protocol MainViewModelProtocol {
    func updateView()
}

class MainViewModel {

    var locations: [String]

    init() {
        locations = ["KHOU", "KPWM", "KAUS"]
    }

    func showAddLocation() {
        print("PRINT: Show the Add Location Modal and capture the returned location.")

    }
}
