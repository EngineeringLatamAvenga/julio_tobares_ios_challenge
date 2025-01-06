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
    var landMark: City
    
    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                Marker(landMark.wrappedName, coordinate: CLLocationCoordinate2D(latitude: landMark.wrappedLat, longitude: landMark.wrappedLon)).tint(.blue)
            }
            .ignoresSafeArea(edges: .all)
            .onAppear {
                let coordinates = CLLocationCoordinate2D(latitude: landMark.wrappedLat, longitude: landMark.wrappedLon)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: coordinates, span: span)
                cameraPosition = .region(region)
            }
            .onChange(of: landMark) { _, newValue in
                let coordinates = CLLocationCoordinate2D(latitude: newValue.wrappedLat, longitude: newValue.wrappedLon)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: coordinates, span: span)
                cameraPosition = .region(region)
            }
        }
    }
}
