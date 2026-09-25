//
//  LogReviewView.swift
//  MealScout
//
//  Created by CLChou on 2026/9/24.
//

import SwiftUI
import MapKit

struct LogReviewView: View {
    @State var viewModel: LogReviewViewModel
    
    init(restaurantIdentifier: MapIdentifier, restaurantName: String) {
        self.viewModel = LogReviewViewModel(restaurantIdentifier: restaurantIdentifier, restaurantName: restaurantName)
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                Text("Writing a review for ")
                Text(viewModel.restaurantName).fontWeight(.bold)
            }
            List {
                
                Section {
                    mealPicker
                    peopleEntry
                    dealSection
                } header: {
                    Text("Meal Time and Deals")
                }
                
                Section {
                    dishSection
                } header: {
                    Text("Original prices for the dishes")
                }
                
                Section {
                    ratingsSection
                }
            }
            .listStyle(.sidebar)
            Button("Submit") {
                
            }
            
        }
        .padding(10)
    }
    
    var mealPicker: some View {
        HStack {
            Text("Meal time: ")
            Spacer()
            Picker("", selection: $viewModel.mealOccasion) {
                ForEach(MealOccasion.allCases, id: \.self) { occasion in
                    Text(occasion.label).tag(occasion)
                }.labelsHidden()
            }
        }
    }
    
    var peopleEntry: some View {
        HStack {
            Text("Dining People: ")
            TextField("0", value: Binding<Int?>(
                get: { viewModel.numDiners == 0 ? nil : viewModel.numDiners },
                set: { viewModel.numDiners = max(0, $0 ?? 0) }
            ), format: .number)
            Spacer()
        }
    }
    
    
    var dealSection: some View {
        let dealBinding = $viewModel.usedDeal
        return VStack(spacing: 10) {
            HStack {
                Text("Did you use a deal?")
                Spacer()
            }
            HStack {
                Text("Source: ")
                TextField("i.e. Eatclub, Uber Eats dine out...", text: dealBinding.redeemSource)
            }
            HStack {
                Text("Discount: ")
                TextField("0", value: Binding<Int?>(
                    get: { viewModel.usedDeal.percentOff == 0 ? nil : viewModel.usedDeal.percentOff },
                    set: { viewModel.usedDeal.percentOff = max(0, $0 ?? 0) }
                ), format: .number)
                .frame(width: 60)
                Text("% off")
                Spacer()
            }
            
            HStack {
                Text("Price Discount: $")
                TextField("", value: Binding<Double?>(
                    get: { viewModel.usedDeal.dollarsOff == 0 ? nil : viewModel.usedDeal.dollarsOff },
                    set: { viewModel.usedDeal.dollarsOff = max(0, (($0 ?? 0) * 100).rounded(.down) / 100) }
                ), format: .number)
                .labelsHidden()
                Spacer()
            }
        }
    }
    
    var dishSection: some View {
        VStack {
            ForEach($viewModel.dishes) { dish in
                DishRow(dish: dish)
            }
        }
    }
    
    var ratingsSection: some View {
        Text("Hello")
    }
    
}

struct DishRow: View {
    @Binding var dish: DishEntry
    var body: some View {
        HStack {
            TextField("Dish name: ...", text: $dish.dishName)
            
            Spacer()
            Text("Price: $")
            TextField("0", value: Binding<Double?>(
                get: { dish.price == 0 ? nil : dish.price },
                set: { dish.price = max(0, $0 ?? 0) }
            ), format: .number)
        }
    }
}

#Preview {
    LogReviewView(restaurantIdentifier: MKMapItem.Identifier(rawValue: "I7C6B3D9E2F1A4A0B")!, restaurantName: "Kaijiken")
}
