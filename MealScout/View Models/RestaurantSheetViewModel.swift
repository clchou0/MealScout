//
//  RestaurantSheetViewModel.swift
//  MealScout
//
//  Created by CLChou on 2026/9/28.
//

import Foundation
import MapKit
import SwiftUI

@Observable
class RestaurantSheetViewModel {
    var mapItem: MKMapItem
    let useCase = FetchRestaurantDetailsUseCase()
    var reviews: [Review] = []
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
        loadReviews()
    }
    
    func loadReviews() {
        guard let identifier = mapItem.identifier else {
            self.reviews = []
            return
        }
        print("Loading...")
        self.reviews = useCase.fetchReviewsFromRestaurant(mapIdentifier: identifier)
    }
}
