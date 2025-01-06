//
//  LandscapeView.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 06/01/2025.
//

import SwiftUI

struct LandscapeView: View {
    
    @EnvironmentObject var viewModel: ListViewModel
    @State private var searchTerm: String = ""
    @State var selectedItem: City?
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
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
                                .onTapGesture {
                                    selectedItem = item
                                }
                            }
                        }
                    } else {
                        List {
                            ForEach(viewModel.filteredCitiesCD, id: \.objectID) { item in
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
                                .onTapGesture {
                                    selectedItem = item
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
                .onChange(of: searchTerm, { _, newValue in
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
                }.frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.95)
                
                VStack {
                    if let selectedItem = selectedItem {
                        MapView(landMark: selectedItem)
                    }
                }.frame(width: geometry.size.width * 0.55, height: geometry.size.height * 0.95)
            }
            .ignoresSafeArea(.all, edges: .all)
        }
    }
}
