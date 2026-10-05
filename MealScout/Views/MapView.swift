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
        mapComponent
        .overlay(alignment: .bottom) {
            buttonsSection.offset(x: 0, y: -80)
        }
        .sheet(isPresented: $viewModel.presentRestaurantSheet, onDismiss: {
            viewModel.selectedFeature = nil
        }) {
            if let item = viewModel.mapItem {
                RestaurantSheet(mapItem: item)
                    .cornerRadius(0)
                    .presentationDetents([.large])
            }
        }
        .sheet(isPresented: $viewModel.presentFilterSheet) {
            FiltersSheet(filter: $viewModel.filter)
        }
    }
    
    var mapComponent: some View {
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
    }
    
    var buttonsSection: some View {
        HStack {
            Button {
                viewModel.presentFilterSheet = true
            } label: {
                Text("Filter").font(.system(size: 20))
            }
            .contentShape(Rectangle())
            .frame(width: 150)
            
            Rectangle()
                .fill(.black)
                .frame(width: 0.5)
            
            Button {
                viewModel.presentResultsSheet = true
            } label: {
                Text("Results").font(.system(size: 20))
            }
            .contentShape(Rectangle())
            .frame(width: 150)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.gray)
        .background(.white)
        .clipShape(Capsule())
        .overlay(
            Capsule().strokeBorder(.black.opacity(0.4), lineWidth: 1.5)
        )
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    MapView()
}
