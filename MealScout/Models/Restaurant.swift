//
//  Restaurant.swift
//  MealScout
//
//  Created by CLChou on 2026/9/23.
//

import Foundation
import MapKit

typealias MapIdentifier = MKMapItem.Identifier

struct Restaurant: Identifiable {
    let id: MapIdentifier
    var name: String
    var tag: [CuisineTag]
}
