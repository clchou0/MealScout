//
//  Review.swift
//  MealScout
//
//  Created by CLChou on 2026/9/23.
//

import Foundation
import MapKit

enum MealOccasion : Hashable, Codable, CaseIterable {
    case breakfast, lunch, dinner, brunch, afternoonTea, snack, supper, dessert, beverage, none
    // I would define supper as late night meal
    var label: String {
        switch self {
        case .breakfast: "Breakfast"
        case .brunch: "Brunch"
        case .lunch: "Lunch"
        case .afternoonTea: "Afternoon Tea"
        case .dinner: "Dinner"
        case .supper: "Supper (Late Night)"
        case .snack: "Snack"
        case .dessert: "Dessert"
        case .beverage: "Beverage"
        case .none: ""
        }
    }
}

struct RatingScores {
    var quality: Double = 5.0
    var price: Double = 5.0
    var portion: Double = 5.0
}

struct Deal {
    var redeemSource: String = ""
    var percentOff: Int = 0
    var dollarsOff: Double = 0.0
    var notes: String = ""
    
    var isEmpty: Bool {
        return redeemSource.isEmpty && percentOff == 0 && dollarsOff == 0
    }
    
    var isValid: Bool {
        if (isEmpty) { return isEmpty }
        return !redeemSource.isEmpty && (percentOff >= 0 || dollarsOff >= 0.0)    // Fill both discount and source
    }
}

struct DishEntry: Identifiable {
    let id: UUID = UUID()
    var dishName: String = ""
    var price: Double = 0
    var quantity: Int = 1
    
    var isValid: Bool {
        return !dishName.isEmpty && price >= 0.0 && quantity > 0
    }
}

struct Review: Identifiable {
    let id: UUID
    var mealOccasion: MealOccasion
    
    // Prices of all consumed dishes
    var dishes: [DishEntry]
    var numDiners: Int
    var totalPrice: Double
    
    var ratings: RatingScores
    var description: String
    
    var usedDeal: Deal? = nil
    
    let restaurant: Restaurant
}
