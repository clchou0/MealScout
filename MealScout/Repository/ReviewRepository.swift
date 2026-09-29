//
//  ReviewRepository.swift
//  MealScout
//
//  Created by CLChou on 2026/9/28.
//

// File: CoreDataReviewRepository.swift
import CoreData

// @MainActor
protocol ReviewRepository {
    func fetchAll() -> [Review]
    func save(_ review: Review)
    func delete(id: UUID)
    func getReviewsForRestaurant(mapIdentifier: MapIdentifier) -> [Review]
}

// @MainActor
final class CoreDataReviewRepository: ReviewRepository {
    
    // Core Data connection and JSON handlers
    private let stack: CoreDataStack
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // Initialize with shared database stack
    init(stack: CoreDataStack = .shared) {
        self.stack = stack
    }

    func fetchAll() -> [Review] {
        // Step A: Ask Core Data for all `ReviewEntity` rows on disk
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        guard let entities = try? stack.context.fetch(request) else { return [] }

        // Step B: Decode each binary `reviewData` blob back into a pure Swift `Review` struct
        return entities.compactMap { entity in
            guard let data = entity.reviewData else { return nil }
            return try? decoder.decode(Review.self, from: data)
        }
    }

    func save(_ review: Review) {
        // Step A: Check if this review already exists in the database
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", review.id as CVarArg)

        let entity: ReviewEntity
        if let existingEntity = try? stack.context.fetch(request).first {
            // Update the existing database row
            entity = existingEntity
        } else {
            // Create a brand new database row
            entity = ReviewEntity(context: stack.context)
            entity.id = review.id
        }

        // Step B: Convert your complex `Review` struct into raw binary data
        entity.reviewData = try? encoder.encode(review)

        // Step C: Persist changes to disk
        try? stack.save()
    }

    func delete(id: UUID) {
        // Step A: Search for the database row matching this ID
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        // Step B: If found, delete the row and save
        if let entity = try? stack.context.fetch(request).first {
            stack.context.delete(entity)
            try? stack.save()
        }
    }
    
    func getReviewsForRestaurant(mapIdentifier: MapIdentifier) -> [Review] {
        return fetchAll().filter { $0.restaurant.id == mapIdentifier }
    }
}
