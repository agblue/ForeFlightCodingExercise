//
//  MainViewModel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

protocol MainViewModelDelegate: MainViewController {
    func refreshView()
    func showLocation(location: String?)
}

class MainViewModel {

    // MARK: - Public Properties
    var dataManager: DataManager
    weak var delegate: MainViewModelDelegate?
    lazy var locationData = Locations(delegate: self)
    var selectedIndex: Int?

    // MARK: - Lifecycle Functions
    init(dataManager: DataManager, delegate: MainViewModelDelegate? = nil) {
        self.dataManager = dataManager
        self.delegate = delegate
    }

    // MARK: - Public Functions
    func selectLocation(at index: Int) {
        guard index < locationData.count else { return }
        if let location = locationData.at(index) {
            selectedIndex = index
            self.delegate?.showLocation(location: location)
        }
    }

    func addLocation(_ location: String) {
        locationData.addLocation(location)
    }

    func removeLocation(at index: Int) {
        if let location = locationData.at(index) {
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
            locationData.removeLocation(at: index)
        }
    }
}

// MARK: - LocationsDelegate
extension MainViewModel: LocationsDelegate {
    func locationsUpdated() {
        self.delegate?.refreshView()
    }
}
