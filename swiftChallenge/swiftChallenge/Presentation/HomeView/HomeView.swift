//
//  HomeView.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 04/01/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var orientation = UIDevice.current.orientation
    
    var body: some View {
        VStack {
            if orientation.isPortrait {
               PortraitView()
            } else if orientation.isLandscape {
                //LandscapeView(selectedItem: City(context: PersistanceController.shared.container.viewContext))
                LandscapeView()
            } else if orientation.isFlat {
                Text("Flat")
            } else {
                Text("Unknown")
            }
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
}
