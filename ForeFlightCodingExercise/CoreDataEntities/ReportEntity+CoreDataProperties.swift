//
//  ReportEntity+CoreDataProperties.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//
//

import Foundation
import CoreData


extension ReportEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReportEntity> {
        return NSFetchRequest<ReportEntity>(entityName: "ReportEntity")
    }

    @NSManaged public var ident: String?
    @NSManaged public var conditions: ConditionsEntity?
    @NSManaged public var forecast: ReportEntity?

}

extension ReportEntity : Identifiable {

}
