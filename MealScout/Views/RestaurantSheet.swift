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
    @State private var navigationPath = NavigationPath()
    
    init(mapItem: MKMapItem) {
        self.viewModel = RestaurantSheetViewModel(mapItem: mapItem)
    }
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Form {
                Section() {
                    HStack {
                        Spacer()
                        Text(viewModel.mapItem.name ?? "unknown")
                            .font(serifFont)
                            .foregroundStyle(.gray)
                        Spacer()
                        
                        Button {
                            print("Tapped Review!!")
                            navigationPath.append(viewModel.mapItem)
                        } label: {
                            Text("Review")
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 10))
                        .disabled(viewModel.mapItem.name == nil || viewModel.mapItem.identifier == nil)
                    }
                }
            }
            .navigationDestination(for: MKMapItem.self) { item in
                if let name = item.name, let identifier = item.identifier {
                    LogReviewView(
                        restaurantIdentifier: identifier,
                        restaurantName: name
                    )
                }
            }
        }
    }
}

//#Preview {
//    // 1. Create a coordinate
//    let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
//    
//    // 2. Create a placemark with standard address fields
//    let placemark = MKPlacemark(
//        coordinate: coordinate,
//        addressDictionary: [
//            "Name": "Sample Restaurant",
//            "Street": "123 Main St",
//            "City": "San Francisco",
//            "State": "CA",
//            "ZIP": "94105"
//        ]
//    )
//    
//    // 3. Initialize MKMapItem with the placemark
//    let mapItem = MKMapItem(placemark: placemark)
//    mapItem.name = "Sample Restaurant"
//    mapItem.phoneNumber = "+1 (555) 123-4567"
//    mapItem.url = URL(string: "https://example.com")
//    
//    // 4. Return your view
//    return RestaurantSheet(mapItem: mapItem)
//}
