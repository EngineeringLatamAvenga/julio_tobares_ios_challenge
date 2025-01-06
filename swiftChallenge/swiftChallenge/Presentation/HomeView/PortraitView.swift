//
//  PortraitView.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 06/01/2025.
//
import SwiftUI

struct PortraitView: View {
    
    @EnvironmentObject var viewModel: ListViewModel
    @State private var searchTerm: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: viewModel.isShowingFavoritesItems ? "star.fill" : "star")
                        .foregroundColor(viewModel.isShowingFavoritesItems ? .yellow : .gray)
                        .frame(width: 50.0, height: 50.0)
                        .onTapGesture {
                            viewModel.isShowingFavoritesItems.toggle()
                        }
                    SearchBar(placeholder: "Filter", text: $searchTerm)
                }
                
                if viewModel.isShowingFavoritesItems {
                    List {
                        ForEach(viewModel.favoriteItems, id: \.objectID) { item in
                            NavigationLink(destination: MapView(landMark: item)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(item.wrappedName), \(String(describing: item.wrappedCountry)) ")
                                            .font(.headline)
                                        Text("lat:\(item.wrappedLat) lon:\(item.wrappedLon) ")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: viewModel.favoriteItems.contains(where: { $0.id == item.id }) ? "star.fill" : "star")
                                        .foregroundColor(viewModel.favoriteItems.contains(where: { $0.id == item.id }) ? .yellow : .gray)
                                        .frame(width: 20.0, height: 20.0)
                                        .onTapGesture {
                                            viewModel.handleFavorites(item: item)
                                        }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                } else {
                    List {
                        ForEach(viewModel.filteredCitiesCD, id: \.objectID) { item in
                            NavigationLink(destination: MapView(landMark: item)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(item.wrappedName), \(String(describing: item.wrappedCountry)) ")
                                            .font(.headline)
                                        Text("lat:\(item.wrappedLat) lon:\(item.wrappedLon) ")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: viewModel.favoriteItems.contains(where: { $0.id == item.id }) ? "star.fill" : "star")
                                        .foregroundColor(viewModel.favoriteItems.contains(where: { $0.id == item.id }) ? .yellow : .gray)
                                        .frame(width: 20.0, height: 20.0)
                                        .onTapGesture {
                                            viewModel.handleFavorites(item: item)
                                        }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }

                if viewModel.isLoading {
                    ProgressView("Cargando...")
                }
                
                Spacer()
            }
            .padding()
            .onChange(of: searchTerm, { oldValue, newValue in
                ///Using asinc after as debouncer
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                   viewModel.searchByCD(searchTerm: newValue)
                }
            })
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "isFirstLoadingDone") {
                    viewModel.getCityAPI()
                    UserDefaults.standard.set(true, forKey: "isFirstLoadingDone")
                } else {
                    viewModel.fetchData()
                }
            }
        }
    }
}
