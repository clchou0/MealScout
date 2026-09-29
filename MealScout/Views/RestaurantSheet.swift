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
            VStack(spacing: 0) {
                headerArea
                    .padding()
                    .background(Color(.systemBackground))
                
                Divider()

                // 📜 2. SCROLLABLE REVIEWS LIST (Only this scrolls)
                List {
                    Section {
                        if viewModel.reviews.isEmpty {
                            emptyPlaceholder
                        } else {
                            reviewsSection
                        }
                    } header: {
                        Text("\(viewModel.reviews.count) reviews made...")
                            .textCase(nil)
                    }
                }
                // .listStyle(.grouped)
            }
            .navigationDestination(for: MKMapItem.self) { item in
                if let name = item.name, let identifier = item.identifier {
                    LogReviewView(
                        restaurantIdentifier: identifier,
                        restaurantName: name
                    )
                }
            }
            .onAppear {
                viewModel.loadReviews()
            }
        }
    }
    var headerArea: some View {
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
    
    var emptyPlaceholder: some View {
        ContentUnavailableView {
            Label("No Reviews Yet", systemImage: "fork.knife")
        } description: {
            Text("Be the first to review this spot and share your thoughts!!")
        }
    }
    var reviewsSection: some View {
        ForEach(viewModel.reviews) { review in
            NavigationLink {
                Text(review.writtenDate.formatted(date: .long, time: .shortened))
            } label: {
                Text(review.writtenDate.formatted(date: .abbreviated, time: .omitted))
            }
        }
    }
}

#Preview {
    // 1. Create a coordinate
    let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
    // 2. Create a placemark with standard address fields
    let placemark = MKPlacemark(
        coordinate: coordinate,
        addressDictionary: [
            "Name": "Sample Restaurant",
            "Street": "123 Main St",
            "City": "San Francisco",
            "State": "CA",
            "ZIP": "94105"
        ]
    )
    
    // 3. Initialize MKMapItem with the placemark
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = "Sample Restaurant"
    mapItem.phoneNumber = "+1 (555) 123-4567"
    mapItem.url = URL(string: "https://example.com")
    
    // 4. Return your view
    return RestaurantSheet(mapItem: mapItem)
}
