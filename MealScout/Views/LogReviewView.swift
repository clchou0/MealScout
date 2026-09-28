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
                Text("Reviewing ")
                Text(viewModel.restaurantName).fontWeight(.bold)
            }
            Form {
                
                Section {
                    mealPicker
                    peopleEntry
                    dealSection
                } header: {
                    Text("Meal Time and Deals")
                        .font(serifFont)
                        .foregroundStyle(.gray)
                }
                
                Section {
                    if ($viewModel.dishes.isEmpty) {
                        Text("Please add your dishes of the day...")
                            .opacity(0.7)
                            .backgroundStyle(.gray)
                    }
                    dishSection
                } header: {
                    HStack {
                        Text("Original prices for the dishes")
                            .font(serifFont)
                            .foregroundStyle(.gray)
                        Spacer()
                        Button {
                            viewModel.dishes.append(DishEntry())
                        } label: {
                            Image(systemName: "plus.square.fill")
                                .backgroundStyle(.blue)
                        }
                    }
                }
                
                Section {
                    HStack{
                        Text("$")
                        
                        TextField("0", value: Binding<Double?>(
                            get: { viewModel.displayedTotalPrice },
                            set: { viewModel.totalPrice = max(0, (($0 ?? 0) * 100).rounded(.down) / 100)  }
                        ), format: .number)
                        
                        Spacer()
                    }
                } header: {
                    Text("Price of your meal")
                        .font(serifFont)
                        .foregroundStyle(.gray)
                }
                
                Section {
                    TextEditor(text: $viewModel.description)
                        .frame(minHeight: 150, maxHeight: .infinity)
                } header: {
                    Text("Comments of your meal")
                        .font(serifFont)
                        .foregroundStyle(.gray)
                }
                
                Section {
                    ratingsSection
                } header: {
                    Text("How did you like your meal?")
                        .font(serifFont)
                        .foregroundStyle(.gray)
                }
            }
            .formStyle(.automatic)
            
            Button("Submit") {
                viewModel.submitReview()
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 10))
        }
        .padding(10)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .resultAlert(alertItem: $viewModel.alertItem)
    }
    
    var mealPicker: some View {
        HStack {
            Text("Meal time: ")
            Spacer()
            Picker("", selection: $viewModel.mealOccasion) {
                ForEach(MealOccasion.allCases, id: \.self) { occasion in
                    Text(occasion.label).tag(occasion)
                }
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
            }
            .pickerStyle(.menu)
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
    
    // Users supplement selected restaurant with tags
    var tagsSeciton: some View {
        Text("Hi")
    }
    
    
    var dealSection: some View {
        let dealBinding = $viewModel.usedDeal
        return VStack(spacing: 10) {
            HStack {
                Text("Did you use a deal?")
                    .font(serifFont)
                    .foregroundStyle(.gray)
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
            
            Text("Brief information: ")
            TextField("", text: dealBinding.notes)
                .lineLimit(5)
        }
    }
    
    var dishSection: some View {
        ForEach($viewModel.dishes) { dish in
            DishRow(dish: dish)
        }
        .onDelete { offsets in
            viewModel.dishes.remove(atOffsets: offsets)
        }
    }
    
    var ratingsSection: some View {
        let rating = $viewModel.ratings
        return VStack {
            RatingSlider(
                name: "Quality",
                description: "How was the food",
                rating: rating.quality
            )
            RatingSlider(
                name: "Portion",
                description: "Was the meal filling",
                rating: rating.portion
            )
            RatingSlider(
                name: "Price",
                description: "Was it worth what you paid",
                rating: rating.price
            )
        }.padding(5)
    }
    
}

struct DishRow: View {
    @Binding var dish: DishEntry
    var body: some View {
        VStack {
            TextField("Dish name: ...", text: $dish.dishName, axis: .vertical)
                .lineLimit(5)
                .frame(maxWidth: .infinity)
            
            HStack {
                Text("Price: $")
                TextField("", value: Binding<Double?>(
                    get: { dish.price == 0 ? nil : dish.price },
                    set: { dish.price = max(0, $0 ?? 0) }
                ), format: .number)
                .labelsHidden()
                
                Spacer()
                
                Text("Orders: ")
                TextField("", value: Binding<Int?>(
                    get: { dish.quantity == 0 ? nil : dish.quantity },
                    set: { dish.quantity = max(0, $0 ?? 0) }
                ), format: .number)
                .labelsHidden()
            }
        }
    }
}

#Preview {
    LogReviewView(restaurantIdentifier: MKMapItem.Identifier(rawValue: "I7C6B3D9E2F1A4A0B")!, restaurantName: "Kaijiken")
}
