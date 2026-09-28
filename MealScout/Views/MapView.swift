//
//  MapView.swift
//  MealScout
//
//  Created by CLChou on 2026/9/28.
//

import SwiftUI
import MapKit

struct MapView: View {    
    @State var mapItem: MKMapItem? = nil
    @State var viewModel: MapViewModel = MapViewModel()
    
    var body: some View {
        Map(position: $viewModel.position, selection: $viewModel.selectedFeature) {
            UserAnnotation()
        }
        .mapStyle(.standard(pointsOfInterest: .including([.restaurant])))
        .mapControls {
            MapUserLocationButton()
        }
        .onChange(of: viewModel.selectedFeature) { _, newValue in
            guard let feature = newValue else { return }
            viewModel.handleChangeFeature(feature: feature)
        }
        .sheet(isPresented: $viewModel.presentSheet, onDismiss: {
            viewModel.selectedFeature = nil
        }) {
            if let item = viewModel.mapItem {
                RestaurantSheet(mapItem: item)
            }
        }.presentationDetents([.medium])
    }
}

#Preview {
    MapView()
}
