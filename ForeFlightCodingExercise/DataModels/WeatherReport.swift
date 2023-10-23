//
//  WeatherReport.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

class WeatherReport: Codable {
    let report: ReportModel?

    init(report: ReportModel?) {
        self.report = report
    }
}
