//
//  ForecastModel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

class ForecastModel: Codable {
    let text: String
    let ident: String
    let dateIssued: Date
    let period: PeriodModel
    let lat: Double
    let lon: Double
    let elevationFt: Float
    let conditions: [ConditionsModel]
}
