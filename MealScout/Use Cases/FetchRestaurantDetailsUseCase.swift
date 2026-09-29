//
//  FetchRestaurantDetailsUseCase.swift
//  MealScout
//
//  Created by CLChou on 2026/9/29.
//

class FetchRestaurantDetailsUseCase {
    private let reviewRepository: ReviewRepository
    private let restaurantRepository: RestaurantRepository
    
    init(reviewRepository: ReviewRepository = CoreDataReviewRepository(),
         restaurantRepository: RestaurantRepository = CoreDataRestaurantRepository()) {
        self.reviewRepository = reviewRepository
        self.restaurantRepository = restaurantRepository
    }
    
    func fetchReviewsFromRestaurant(mapIdentifier: MapIdentifier) -> [Review] {
        return reviewRepository.getReviewsForRestaurant(mapIdentifier: mapIdentifier)
    }
}
