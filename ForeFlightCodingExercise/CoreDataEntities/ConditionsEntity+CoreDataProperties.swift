//
//  ConditionsEntity+CoreDataProperties.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//
//

import Foundation
import CoreData


extension ConditionsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConditionsEntity> {
        return NSFetchRequest<ConditionsEntity>(entityName: "ConditionsEntity")
    }

    @NSManaged public var text: String?
    @NSManaged public var ident: String?
    @NSManaged public var dateIssued: Date?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var elevationFt: Float
    @NSManaged public var tempC: Float
    @NSManaged public var dewpointC: Float
    @NSManaged public var pressureHg: Float
    @NSManaged public var pressureHpa: Double
    @NSManaged public var relativeHumidity: Float
    @NSManaged public var flightRules: String?

}

extension ConditionsEntity : Identifiable {

}
