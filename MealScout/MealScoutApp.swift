//
//  MealScoutApp.swift
//  MealScout
//
//  Created by CLChou on 2026/9/22.
//

import SwiftUI
import CoreData
import MapKit

@main
struct MealScoutApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            LogReviewView(restaurantIdentifier: MKMapItem.Identifier(rawValue: "I7C6B3D9E2F1A4A0B")!, restaurantName: "88 Asean food")
        }
    }
}
