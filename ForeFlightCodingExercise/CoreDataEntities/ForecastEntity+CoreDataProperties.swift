//
//  ForecastEntity+CoreDataProperties.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//
//

import Foundation
import CoreData


extension ForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastEntity> {
        return NSFetchRequest<ForecastEntity>(entityName: "ForecastEntity")
    }

    @NSManaged public var text: String?
    @NSManaged public var ident: String?
    @NSManaged public var dateIssued: Date?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var elevationFt: Float
    @NSManaged public var conditions: NSSet?
    @NSManaged public var report: ReportEntity?

}

// MARK: Generated accessors for conditions
extension ForecastEntity {

    @objc(addConditionsObject:)
    @NSManaged public func addToConditions(_ value: ForecastConditionEntity)

    @objc(removeConditionsObject:)
    @NSManaged public func removeFromConditions(_ value: ForecastConditionEntity)

    @objc(addConditions:)
    @NSManaged public func addToConditions(_ values: NSSet)

    @objc(removeConditions:)
    @NSManaged public func removeFromConditions(_ values: NSSet)

}

extension ForecastEntity : Identifiable {

}
