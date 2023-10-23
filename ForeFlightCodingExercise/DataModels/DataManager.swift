//
//  DataManager.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import CoreData
import Foundation

class DataManager {

    var moc: NSManagedObjectContext?
    private let container = NSPersistentContainer(name: "ForeFlightWeather")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("FATAL ERROR: Core Data is unable to load persistent data store: \(error.localizedDescription)")
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            self.moc = self.container.viewContext
        }
    }

    func getReportFor(location: String) async -> Bool {
        guard let url = URL(string: "https://qa.foreflight.com/weather/report/\(location)") else { return false }
        var request = URLRequest(url: url)
        request.setValue("1", forHTTPHeaderField: "ff-coding-exercise")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let weatherReport = try decoder.decode(WeatherReport.self, from: data)
            if let report = weatherReport.report {
                saveReportToCoreData(location: location, report: report)
                return true
            }

        } catch {
            // Handle Thrown errors here.
            print("PRINT: Decoding Error: \(error.localizedDescription)")
        }
        return false
    }

    private func saveReportToCoreData(location: String, report: ReportModel) {
        guard let moc = moc else { return }
        let reportEntity = ReportEntity(context: moc)
        reportEntity.ident = location

        let conditionsEntity = ConditionsEntity(context: moc)
        conditionsEntity.dateIssued = report.conditions.dateIssued
        conditionsEntity.dewpointC = report.conditions.dewpointC ?? 0.0
        conditionsEntity.elevationFt = report.conditions.elevationFt
        conditionsEntity.flightRules = report.conditions.flightRules
        conditionsEntity.ident = report.conditions.ident
        conditionsEntity.lat = report.conditions.lat
        conditionsEntity.lon = report.conditions.lon
        conditionsEntity.pressureHg = report.conditions.pressureHg ?? 0.0
        conditionsEntity.pressureHpa = report.conditions.pressureHpa ?? 0.0
        conditionsEntity.relativeHumidity = report.conditions.relativeHumidity
        conditionsEntity.tempC = report.conditions.tempC ?? 0.0
        conditionsEntity.text = report.conditions.text
        reportEntity.conditions = conditionsEntity

        let forecastEntity = ForecastEntity(context: moc)
        forecastEntity.dateIssued = report.forecast.dateIssued
        forecastEntity.elevationFt = report.forecast.elevationFt
        forecastEntity.ident = report.forecast.ident
        forecastEntity.lat = report.forecast.lat
        forecastEntity.lon = report.forecast.lon
        forecastEntity.text = report.forecast.text

        for condition in report.forecast.conditions {
            let forecastCondition = ForecastConditionEntity(context: moc)
            forecastCondition.dateIssued = condition.dateIssued
            forecastCondition.elevationFt = condition.elevationFt
            forecastCondition.flightRules = condition.flightRules
            forecastCondition.lat = condition.lat
            forecastCondition.lon = condition.lon
            forecastCondition.relativeHumidity = condition.relativeHumidity
            forecastCondition.text = condition.text
            forecastEntity.addToConditions(forecastCondition)
        }

        if moc.hasChanges {
            try? moc.save()
        }
    }
}
