//
//  ForecastConditionEntity+CoreDataProperties.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//
//

import Foundation
import CoreData


extension ForecastConditionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastConditionEntity> {
        return NSFetchRequest<ForecastConditionEntity>(entityName: "ForecastConditionEntity")
    }

    @NSManaged public var text: String?
    @NSManaged public var dateIssued: Date?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var elevationFt: Float
    @NSManaged public var relativeHumidity: Float
    @NSManaged public var flightRules: String?
    @NSManaged public var forecast: ForecastEntity?

}

extension ForecastConditionEntity : Identifiable {

}
