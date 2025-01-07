//
//  CoreDataManager.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 05/01/2025.
//

import CoreData

final class CoreDataManager {
    
    let moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    // MARK: - CoreData
    func fetchData() -> [City] {
        let request = City.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \City.name, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        if let tasks = try? self.moc.fetch(request) {
            return tasks
        }
        return []
    }

    func addItem(item: CityItem) {
        let newItem = City(context: moc)
        newItem.name = item.name
        newItem.country = item.country
        newItem.lat = item.coord.lat
        newItem.lon = item.coord.lon
        
        do {
            try moc.save()
        } catch {
            print("Failed to add task")
        }
    }
    
    func addBatchItems(items: [CityItem]) {
        let tempObj: [[String: Any]] = items.map { item in
                return [
                    "id": item.id,
                    "name": item.name,
                    "country": item.country,
                    "lon": item.coord.lon,
                    "lat": item.coord.lat
                ]
        }
        
        moc.performAndWait {
            do {
                let batchInsertRequest = NSBatchInsertRequest(entity: City.entity(), objects: tempObj)
                try moc.execute(batchInsertRequest)
                try moc.save()
            } catch {
                print("Error al guardar en CoreData: \(error.localizedDescription)")
            }
        }
    }
    
    func updateFavStatus(status: Bool, for name: String) {
        let request: NSFetchRequest<City> = City.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \City.name, ascending: true)
        request.predicate = NSPredicate(format: "name == %@", name)
        request.sortDescriptors = [sortDescriptor]

        do {
            let cities = try moc.fetch(request)
            if let city = cities.first {
                city.isFavorite = status

                try moc.save()
                print("Favorites updated successfully.")
            } else {
                print("City not found.")
            }
        } catch {
            print("Failed to fetch or save: \(error.localizedDescription)")
        }
    }
}
