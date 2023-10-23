//
//  ReportModel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

class ReportModel: Codable {
    let conditions: ConditionsModel
    let forecast: ForecastModel
}
