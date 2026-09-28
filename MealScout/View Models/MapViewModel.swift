//
//  MapViewModel.swift
//  MealScout
//
//  Created by CLChou on 2026/9/28.
//

import Foundation
import MapKit
import SwiftUI

@Observable
class MapViewModel {
    var position: MapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    ))
    
    var selectedFeature: MapFeature? = nil
    var presentSheet: Bool = false
    var mapItem: MKMapItem? = nil
    
    init() {
        
    }
    
    func handleChangeFeature(feature: MapFeature) {
        print("Tapped: \(feature.title ?? "unknown")")
        Task {
            mapItem = await fetchMapItem(for: feature)
            presentSheet = true
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
