//
//  RestaurantSheet.swift
//  MealScout
//
//  Created by CLChou on 2026/9/28.
//

import SwiftUI
import MapKit

struct RestaurantSheet: View {
    @State var viewModel: RestaurantSheetViewModel
    init(mapItem: MKMapItem) {
        self.viewModel = RestaurantSheetViewModel(mapItem: mapItem)
    }
    var body: some View {
        Form {
            Text(viewModel.mapItem.name ?? "unknown")
            Text("\(viewModel.mapItem.address)")
        }
    }
}

//#Preview {
//    RestaurantSheet()
//}
