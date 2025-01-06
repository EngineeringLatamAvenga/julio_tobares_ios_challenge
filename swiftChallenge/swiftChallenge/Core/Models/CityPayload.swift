//
//  CityPayload.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 04/01/2025.
//

//Example
/*
 {
    "country":"UA",
    "name":"Hurzuf",
    "_id":707860,
    "coord":{
        "lon":34.283333,
        "lat":44.549999
    }
 }
 */

import MapKit

class CityItem: NSObject, Identifiable, Codable {
    let country: String
    let name: String
    let id: Int
    let coord: Coordinates
    
    enum CodingKeys: String, CodingKey {
        case country = "country"
        case name = "name"
        case id = "_id"
        case coord = "coord"
    }
}

class Coordinates: Codable {
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lon"
    }
}
