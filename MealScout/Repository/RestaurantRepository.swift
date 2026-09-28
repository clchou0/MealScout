//
//  RestaurantRepository.swift
//  MealScout
//
//  Created by CLChou on 2026/9/28.
//

import Foundation
import CoreData
import MapKit

// @MainActor
protocol RestaurantRepository {
    func fetchAll() -> [Restaurant]
    func save(_ review: Restaurant)
    func delete(id: MapIdentifier)
    func find(by id: MapIdentifier) -> Restaurant?
    
    func findOrCreateRestaurant(id: MapIdentifier, restaurantName: String) -> Restaurant
}

// @MainActor
final class CoreDataRestaurantRepository: RestaurantRepository {
    private let stack: CoreDataStack
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
    }
    
    func fetchAll() -> [Restaurant] {
        let request: NSFetchRequest<RestaurantEntity> = RestaurantEntity.fetchRequest()
        guard let entities = try? stack.context.fetch(request) else { return [] }
        
        return entities.compactMap { entity in
            guard let data = entity.restaurantData else { return nil }
            return try? decoder.decode(Restaurant.self, from: data)
        }
    }
    
    func save(_ restaurant: Restaurant) {
        let request: NSFetchRequest<RestaurantEntity> = RestaurantEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", restaurant.id.rawValue)
        
        let entity: RestaurantEntity
        if let existingEntity = try? stack.context.fetch(request).first {
            entity = existingEntity
        } else {
            entity = RestaurantEntity(context: stack.context)
            entity.id = restaurant.id.rawValue
        }
        
        entity.restaurantData = try? encoder.encode(restaurant)
        try? stack.save()
    }

    func delete(id: MapIdentifier) {
        let request: NSFetchRequest<RestaurantEntity> = RestaurantEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.rawValue)

        if let entity = try? stack.context.fetch(request).first {
            stack.context.delete(entity)
            try? stack.save()
        }
    }
    
    func find(by id: MapIdentifier) -> Restaurant? {
        let request: NSFetchRequest<RestaurantEntity> = RestaurantEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.rawValue)
        
        guard let entity = try? stack.context.fetch(request).first,
              let data = entity.restaurantData else { return nil }
        
        return try? decoder.decode(Restaurant.self, from: data)
    }
    
    func findOrCreateRestaurant(id: MapIdentifier, restaurantName: String) -> Restaurant {
        if var existing = find(by: id) {
            print("Restaurant exists")
            existing.name = restaurantName
            save(existing)
            return existing
        } else {
            print("Restaurant \(id.rawValue) added")
            let newRestaurant = Restaurant(id: id, name: restaurantName, tag: [])
            save(newRestaurant)
            return newRestaurant
        }
    }
}
