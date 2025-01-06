//
//  Coordinate+CoreDataProperties.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 06/01/2025.
//
//

import Foundation
import CoreData


extension Coordinate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coordinate> {
        return NSFetchRequest<Coordinate>(entityName: "Coordinate")
    }

    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var origin: City?

}

extension Coordinate : Identifiable {

}
