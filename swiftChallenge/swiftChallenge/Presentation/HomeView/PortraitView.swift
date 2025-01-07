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
    @State private var showSheet: Bool = false
    
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

                List {
                    ForEach(viewModel.isShowingFavoritesItems ? viewModel.favoriteItems.reversed() : viewModel.filteredCitiesCD, id: \.objectID) { item in
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
                                Image(systemName:  item.isFavorite ? "star.fill" : "star")
                                    .foregroundColor( item.isFavorite ? .yellow : .gray)
                                    .frame(width: 20.0, height: 20.0)
                                    .onTapGesture {
                                        viewModel.handleFavorites(item: item)
                                    }
                                    .onAppear {
                                        if item.isFavorite {
                                            viewModel.handleFavorites(item: item)
                                        }
                                    }
                                Image(systemName: "info.circle")
                                    .foregroundColor(.gray)
                                    .frame(width: 20.0, height: 20.0)
                                    .onTapGesture {
                                        showSheet.toggle()
                                    }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }

                if viewModel.isLoading {
                    ProgressView("Loading...")
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
            .sheet(isPresented: $showSheet) {
                VStack {
                    Text("Meet us!")
                        .font(.headline)
                    Spacer().frame(height: 10)
                    Text("We can take you to another places with our tastes from Asia")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer().frame(height: 20)
                    Button("Close") {
                        showSheet = false
                    }
                }
                .presentationDetents([.fraction(0.3), .medium])
                .presentationDragIndicator(.visible)
            }
        }
    }
}
