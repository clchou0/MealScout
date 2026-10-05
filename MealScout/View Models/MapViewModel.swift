//
//  MapViewModel.swift
//  MealScout
//
//  Created by CLChou on 2026/9/28.
//

import Foundation
import MapKit
import SwiftUI

struct FilterObject: Equatable {
    var restaurantName: String = ""
    var dishName: String = ""
    
    var oneDinerRestrict: Bool = false
    var desiredPricePP: Double = .infinity
    var selectedMealTypes: [MealOccasion] = MealOccasion.AllCases()
    
    var selectedCuisineTags: [CuisineTag] = []
    var newSelectedTag: CuisineTag? = nil
    
    var desiredRating: RatingScores = RatingScores(quality: 1.0, price: 1.0, portion: 1.0)
    
    
    func evaluate (review: Review) -> Bool {
        guard restaurantName.isEmpty || review.restaurant.name.localizedCaseInsensitiveContains(restaurantName) else { return false }
        
        guard dishName.isEmpty || review.dishes.contains(where: { $0.dishName.localizedCaseInsensitiveContains(dishName)})
            else { return false }
        
        guard selectedMealTypes.contains(review.mealOccasion) else { return false }
        
        if oneDinerRestrict {
            guard review.numDiners == 1 else { return false }
        }
        
        guard desiredPricePP >= (review.totalPrice / Double(review.numDiners)) else { return false }
        
        guard review.restaurant.tags.contains(where: { selectedCuisineTags.contains($0) })
            else { return false }
        
        let rate = review.ratings
        guard rate.quality >= desiredRating.quality
                && rate.portion >= desiredRating.portion
                && rate.price >= desiredRating.price else { return false }
        
        return true
    }
    
    var isDefault: Bool { self == FilterObject() }
}

@Observable
class MapViewModel {
    var position: MapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    ))
    
    var selectedFeature: MapFeature? = nil
    var presentRestaurantSheet: Bool = false
    var presentFilterSheet: Bool = false
    var presentResultsSheet: Bool = false
    
    var mapItem: MKMapItem? = nil
    var filter = FilterObject()
    
    init() {
        
    }
    
    func handleChangeFeature(feature: MapFeature) {
        print("Tapped: \(feature.title ?? "unknown")")
        Task {
            mapItem = await fetchMapItem(for: feature)
            presentRestaurantSheet = true
        }
    }
    
    func fetchMapItem(for feature: MapFeature) async -> MKMapItem? {
        let request = MKMapItemRequest(feature: feature)
        do {
            return try await request.mapItem
        } catch {
            print("Failed to get map item: \(error.localizedDescription)")
            return nil
        }
    }
}
