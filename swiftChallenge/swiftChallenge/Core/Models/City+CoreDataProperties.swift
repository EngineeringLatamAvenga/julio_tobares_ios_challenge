//
//  City+CoreDataProperties.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 06/01/2025.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var country: String?
    @NSManaged public var id: Int16
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var name: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var coordinates: Coordinate?

    
    public var wrappedId: Int16 {
        get { id }
    }
    
    public var wrappedName: String {
        name ?? "Unknown"
    }
    
    public var wrappedCountry: String {
        country ?? "Unknown"
    }
    
    public var wrappedLat: Double {
        get { lat }
    }
    
    public var wrappedLon: Double {
        get { lon }
    }
    
    public var wrappedIsFavoriteStatus: Bool {
        get { isFavorite }
        set { isFavorite = newValue }
    }
}

extension City : Identifiable {

}
