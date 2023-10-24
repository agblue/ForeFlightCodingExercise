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

    private var timer: Timer?

    init(dataManager: DataManager, location: String? = nil, delegate: LocationDetailViewModelProtocol? = nil) {
        self.dataManager = dataManager
        self.location = location
        self.delegate = delegate

        startTimer()
    }

    deinit {
        self.timer?.invalidate()
    }

    private func startTimer() {
        // Schedule a 30 second timer
        self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { [weak self] _ in
            self?.fetchData()
        })
        self.timer?.fire()
    }

    func loadData() {
        guard let location = location else {
            self.delegate?.refreshView()
            return
        }
        let request = ReportEntity.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(ReportEntity.ident)) =[c] %@", location)
        if let report = try? dataManager.moc?.fetch(request).first {
            conditions = report.conditions
            forecast = report.forecast
            self.delegate?.refreshView()
        }
    }

    func fetchData() {
        guard let location = location else { return }
        Task {
            let result = await dataManager.getReportFor(location: location)
            if result {
                DispatchQueue.main.async { [weak self] in
                    self?.loadData()
                }
            }
        }
    }
}
