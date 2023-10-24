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

    var dataManager: DataManager
    var locations = Locations()

    weak var delegate: MainViewModelDelegate?

    init(dataManager: DataManager, delegate: MainViewModelDelegate? = nil) {
        self.dataManager = dataManager
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

    func removeLocation(at index: Int) {
        let location = locations.recentLocations[index]
        let request = ReportEntity.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(ReportEntity.ident)) =[c] %@", location)
        if let reports = try? dataManager.moc?.fetch(request) {
            for report in reports {
                dataManager.moc?.delete(report)
            }
            if let hasChanges = dataManager.moc?.hasChanges, hasChanges == true {
                try? dataManager.moc?.save()
            }
        }
        locations.removeLocation(at: index)
    }
}
