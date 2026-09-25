//
//  LogReviewViewModel.swift
//  MealScout
//
//  Created by CLChou on 2026/9/23.
//

import Foundation

@Observable
class LogReviewViewModel {
    let restaurantIdentifier: MapIdentifier
    let restaurantName: String
    
    var mealOccasion: MealOccasion = .none
    var dishes: [DishEntry] = []
    var numDiners: Int = 0
    
    var ratings: RatingScores = RatingScores()
    var description: String = ""
    
    var usedDeal: Deal = Deal()
    var totalPrice: Double = 0.0
    
    init(restaurantIdentifier: MapIdentifier, restaurantName: String) {
        self.restaurantIdentifier = restaurantIdentifier
        self.restaurantName = restaurantName
    }
}
