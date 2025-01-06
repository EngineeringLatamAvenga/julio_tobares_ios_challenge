//
//  ListViewModel.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 04/01/2025.
//

import SwiftUI
import Combine
import CoreData

class ListViewModel: ObservableObject {
    let moc: NSManagedObjectContext
    let cdManager: CoreDataManager
    
    var orientation: Orientation = .portrait
    var originalCitiesCD: [City] = []
    var subscribers = Set<AnyCancellable>()
    var isFirtsLoading: Bool = true
    var cancellables = Set<AnyCancellable>()
    
    @Published var favoriteItems: [City] = []
    @Published var isShowingFavoritesItems: Bool = false
    
    @Published var filteredCitiesCD: [City] = []
    @Published var isLoading = false    
    @Published var searchTerm: String = ""
    @Published var predicate: NSPredicate? = nil
    

    init(moc: NSManagedObjectContext) {
        self.moc = moc
        cdManager = CoreDataManager(moc: moc)
    }
    
    //Get from API
    func getCityAPI() {
        guard !isLoading else { return }
        
        isLoading = true
        guard let url = URL(string: Constants.mockDataBaseUrl) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [CityItem].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    //Show alert with error
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                case .finished:
                    break
                }
            }, receiveValue: { cities in
                DispatchQueue.main.async {
                    self.cdManager.addBatchItems(items: cities)
                    self.isLoading = false
                }
            })
            .store(in: &cancellables)
    }

    // MARK: - CoreData
    func fetchData() {
        filteredCitiesCD = []
        isLoading = true
        DispatchQueue.main.async {
            let result = self.cdManager.fetchData()
            self.filteredCitiesCD = result
            if self.originalCitiesCD.isEmpty {
                self.originalCitiesCD = result
            }
            self.isLoading = false
        }
    }
    
    ///Search by Linear Search -> Not efficient
    func searchByFilterArray(searchTerm: String) {
        let tempArray = filteredCitiesCD
        if !searchTerm.isEmpty {
            DispatchQueue.main.async {
                self.filteredCitiesCD = tempArray.filter {
                    if let name = $0.name {
                        return name.lowercased().contains(searchTerm.lowercased())
                    }
                    return false
                }
            }
        }
    }
    
    ///Search by CoreData NSPredicate -> Changing the limit of entities
    func searchByCD(searchTerm: String) {
        let request: NSFetchRequest<City> = City.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \City.name, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        request.fetchLimit = 100000
        isLoading = true
        if !searchTerm.isEmpty {
            request.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchTerm)
            request.fetchLimit = 20000
        }
        
        filteredCitiesCD = []
        
        DispatchQueue.main.async {
            do {
                let cities = try self.moc.fetch(request)
                self.filteredCitiesCD = cities
                self.isLoading = false
            } catch {
                print("Error al recuperar las ciudades: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func handleFavorites(item: City) {
        DispatchQueue.main.async {
            if !self.favoriteItems.contains(where: { $0.id == item.id }) {
                self.favoriteItems.append(item)
                item.isFavorite = true
            } else {
                self.favoriteItems.removeAll { $0.id == item.id }
                item.isFavorite = false
            }
            self.cdManager.updateFavStatus(status: item.isFavorite, for: item.wrappedName)
        }
    }
}
