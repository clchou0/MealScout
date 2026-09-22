//
//  MealScoutApp.swift
//  MealScout
//
//  Created by CLChou on 2026/9/22.
//

import SwiftUI
import CoreData

@main
struct MealScoutApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
