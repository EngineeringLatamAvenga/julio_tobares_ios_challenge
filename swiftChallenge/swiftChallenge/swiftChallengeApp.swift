//
//  swiftChallengeApp.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 04/01/2025.
//

import SwiftUI
import CoreData

@main
struct swiftChallengeApp: App {
    let moc = PersistanceController.shared.container.viewContext
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, moc)
                .environmentObject(ListViewModel(moc: moc))
        }
    }
}
