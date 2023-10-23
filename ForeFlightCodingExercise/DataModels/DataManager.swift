//
//  DataManager.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

class DataManager {
    func getReportFor(location: String) async -> WeatherReport? {
        guard let url = URL(string: "https://qa.foreflight.com/weather/report/\(location)") else { return nil }
        var request = URLRequest(url: url)
        request.setValue("1", forHTTPHeaderField: "ff-coding-exercise")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(WeatherReport.self, from: data)
        } catch {
            // Handle Thrown errors here.
            print("PRINT: Decoding Error: \(error.localizedDescription)")
        }
        return nil
    }
}
