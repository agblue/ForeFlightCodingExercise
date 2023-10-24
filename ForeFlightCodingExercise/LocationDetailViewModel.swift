//
//  LocationDetailViewModel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

protocol LocationDetailViewModelProtocol: AnyObject {
    func refreshView()
}

class LocationDetailViewModel {
    var dataManager: DataManager
    var location: String?
    weak var delegate: LocationDetailViewModelProtocol?
    var selectedDetailIndex = 0
    var conditions: ConditionsEntity?
    var forecast: ForecastEntity?

    init(dataManager: DataManager, location: String? = nil, delegate: LocationDetailViewModelProtocol? = nil) {
        self.dataManager = dataManager
        self.location = location
        self.delegate = delegate
    }

    func loadData() {
        guard let location = location else { return }
        let request = ReportEntity.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(ReportEntity.ident)) = %@", location.lowercased())
        if let report = try? dataManager.moc?.fetch(request).first {
            conditions = report.conditions
            forecast = report.forecast
            self.delegate?.refreshView()
        }

    }
}
