//
//  swiftChallengeTests.swift
//  swiftChallengeTests
//
//  Created by Julio Gabriel Tobares on 04/01/2025.
//

import XCTest
import CoreData
@testable import swiftChallenge

class swiftChallengeTests: XCTestCase {

    let jsonData = """
    [
        {
            "_id": 1,
            "name": "Paris",
            "country": "FR",
            "coord":{
                "lon": 2.3522,
                "lat": 48.8566
            }
        },
        {
            "_id": 2,
            "name": "Berlin",
            "country": "DE",
            "coord":{
                "lon": 13.4050,
                "lat": 52.5200
            }
        },
        {
            "_id": 3,
            "name": "Rome",
            "country": "IT",
            "coord":{
                "lon": 12.4964,
                "lat": 41.9028
            }
        }
    ]
    """.data(using: .utf8)!
    
    var moc: NSManagedObjectContext!
    var viewModel: ListViewModel!

    override func setUp() {
        super.setUp()

        // Configurar el stack de Core Data en memoria
        let modelURL = Bundle.main.url(forResource: "CityCD", withExtension: "momd")!
        let mom = NSManagedObjectModel(contentsOf: modelURL)!
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        do {
            let storeURL = URL(fileURLWithPath: "/dev/null") // Usar una ubicación ficticia
            try psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: storeURL, options: nil)
            moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            moc.persistentStoreCoordinator = psc
        } catch {
            fatalError("Error al configurar el entorno de Core Data en memoria: \(error)")
        }

        viewModel = ListViewModel(moc: moc)
    }
    
    override func tearDown() {
        moc = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_searchByCD_withSearchTerm() async throws {
        // Given

        //Create entities
        let city1 = City(context: moc)
        city1.name = "Paris"
        city1.country = "FR"
        city1.lat = 48.85
        city1.lon = 2.35
        
        let city2 = City(context: moc)
        city2.name = "Madrid"
        city2.country = "ES"
        city2.lat = 40.41
        city2.lon = -3.70
        
        let city3 = City(context: moc)
        city3.name = "London"
        city3.country = "GB"
        city3.lat = 51.50
        city3.lon = -0.12
        
        //Save entities
        do {
            try moc.save()
        } catch {
            print("Failed to add task")
        }
        
        //When
        //Fetch entities
        // viewModel.searchByCD(searchTerm: searchTerm)
        let searchTerm = "Paris"
        let request = viewModel.createSearchRequest(searchTerm: searchTerm)
        
        do {
            viewModel.filteredCitiesCD = try self.moc.fetch(request)
        } catch {
            print("Failed to fetchData")
        }
        
        //Then
        let filteredCities = viewModel.filteredCitiesCD
        XCTAssertEqual(filteredCities.count, 1, "Should be just one matching city: 'Paris'")
        XCTAssertEqual(filteredCities.first?.name, "Paris", "City should be 'Paris'")
    }
}
