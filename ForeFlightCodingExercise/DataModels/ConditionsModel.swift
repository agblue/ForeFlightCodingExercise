//
//  ConditionsModel.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import Foundation

class ConditionsModel: Codable {
    let text: String
    let ident: String?
    let dateIssued: Date
    let lat: Double
    let lon: Double
    let elevationFt: Float

    let tempC: Float?
    let dewpointC: Float?
    let pressureHg: Float?
    let pressureHpa: Double?

    let relativeHumidity: Float
    let flightRules: String
}
