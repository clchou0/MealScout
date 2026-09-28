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
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
}
