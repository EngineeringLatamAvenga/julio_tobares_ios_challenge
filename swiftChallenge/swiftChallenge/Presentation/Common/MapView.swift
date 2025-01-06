//
//  MapView.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 04/01/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var landMark: City
    
    
    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                Marker(landMark.wrappedName, coordinate: coordinates).tint(.blue)
            }
            .ignoresSafeArea(edges: .all)
            .onAppear {
                coordinates = CLLocationCoordinate2D(latitude: landMark.lat, longitude: landMark.lon)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: coordinates, span: span)
                cameraPosition = .region(region)
            }
            .onChange(of: landMark) { _, newValue in
                coordinates = CLLocationCoordinate2D(latitude: newValue.lat, longitude: newValue.lon)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: coordinates, span: span)
                cameraPosition = .region(region)
            }
        }
    }
}
