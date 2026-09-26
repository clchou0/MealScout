//
//  LogReviewUseCase.swift
//  MealScout
//
//  Created by CLChou on 2026/9/26.
//

import Foundation

enum LogReviewError {
    case invalidMealOccasion
    case dishesEmpty
    case invalidPrice
    case invalidDeal
    
    var errorDescription: String? {
        switch self {
        case .invalidMealOccasion: "Please enter when you had the meal!"
        case .dishesEmpty: "Please enter at least one dish you had for the meal!"
        case .invalidPrice: "Please enter a valid value for the price!"
        case .invalidDeal: "Please leave the deal empty or enter a valid value!"
        }
    }
}

class LogReviewUseCase {
    func execute() {
        
    }
}
