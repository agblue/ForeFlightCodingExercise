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
    // MARK: - Public Properties
    var dataManager: DataManager
    var location: String?
    weak var delegate: LocationDetailViewModelProtocol?
    var selectedDetailIndex = 0
    var conditions: ConditionsEntity?
    var forecast: ForecastEntity?

    // MARK: - Private Properties
    private var timer: Timer?

    // MARK: - Lifecycle Functions
    init(dataManager: DataManager, location: String? = nil, delegate: LocationDetailViewModelProtocol? = nil) {
        self.dataManager = dataManager
        self.location = location
        self.delegate = delegate
        startTimer()
    }

    deinit {
        self.timer?.invalidate()
    }

    // MARK: - Public Functions
    func startTimer() {
        self.timer?.invalidate()
        guard location != nil else { return }
        
        // Schedule a 15 second timer
        self.timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { [weak self] _ in
            self?.fetchData()
        })
    }

    func loadData() {
        conditions = nil
        forecast = nil
        guard let location = location else {
            self.delegate?.refreshView()
            return
        }
        let request = ReportEntity.fetchRequest()
        let reports = try? dataManager.moc?.fetch(request)
        request.predicate = NSPredicate(format: "\(#keyPath(ReportEntity.ident)) =[c] %@", location)
        let report = try? dataManager.moc?.fetch(request).first
        if let report = report {
            conditions = report.conditions
            forecast = report.forecast
            self.delegate?.refreshView()
        } else {
            fetchData()
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
