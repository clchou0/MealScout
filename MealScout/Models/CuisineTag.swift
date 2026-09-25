//
//  RestaurantTag.swift
//  MealScout
//
//  Created by CLChou on 2026/9/23.
//

import Foundation

struct CountryGlossary {
    static let allowedCountryCodes: Set<String> = [
        "TH", // Thailand
        "JP", // Japan
        "CN", // China
        "MX", // Mexico
        "US", // United States
        "DE", // Germany
        "IT", // Italy
        "ES", // Spain
        "FR", // France
        "TW", // Taiwan
        "ID", // Indonesia
        "MY", // Malaysia
        "VN", // Vietnam
        "BR", // Brazil
        "IN", // India
        "KR", // Korea
        "PK", // Pakistan
        "LB", // Lebanon
        "TR", // Turkey
        "GR", // Greece
        "GB", // United Kingdom
    ]
    
    static let cuisineNameByCode: [String: String] = [
        "TH": "Thai",
        "JP": "Japanese",
        "CN": "Chinese",
        "MX": "Mexican",
        "US": "American",
        "DE": "German",
        "IT": "Italian",
        "ES": "Spanish",
        "FR": "French",
        "TW": "Taiwanese",
        "ID": "Indonesian",
        "MY": "Malaysian",
        "VN": "Vietnamese",
        "BR": "Brazilian",
        "IN": "Indian",
        "KR": "Korean",
        "PK": "Pakistani",
        "LB": "Lebanese",
        "TR": "Turkish",
        "GR": "Greek",
        "GB": "British"
    ]
}

enum CuisineTag: Hashable {
    // Non-nationality
    case cafe
    case fastFood
    case dessert
    case drinksFocused
    case bakery
    case buffet
    case seafood
    case bbq
    case fingerFood
    
    // Nationality
    case country(code: String)          // Common cuisines, will have their own icons
    case international(name: String)     // U can type the cuisine in yourself, would have default icon
    
    var displayIcon: String {
        
        return switch (self) {
            case .country(let code): flag(from: code)
            case .international(_): "🌍"
            case .cafe: "☕️"
            case .fastFood: "🍔"
            case .dessert: "🍰"
            case .drinksFocused: "🍸"
            case .bakery: "🥐"
            case .buffet: "🍽️"
            case .seafood: "🦐"
            case .bbq: "🍖"
            case .fingerFood: "🍢"
        }
    }
    
    func flag(from countryCode: String) -> String {
        let base: UInt32 = 127397
        var flagString = ""
        
        for scalar in countryCode.uppercased().unicodeScalars {
            if let unicodeScalar = UnicodeScalar(base + scalar.value) {
                flagString.unicodeScalars.append(unicodeScalar)
            }
        }
        
        return flagString
    }
    
    var labelName: String {
        switch self {
        case .cafe: "Cafe"
        case .fastFood: "Fast Food"
        case .dessert: "Dessert"
        case .drinksFocused: "Drinks Focused"
        case .bakery: "Bakery"
        case .buffet: "Buffet"
        case .seafood: "Seafood"
        case .bbq: "BBQ"
        case .fingerFood: "Finger Food"
        case .country(let code):
            CountryGlossary.cuisineNameByCode[code] ?? code
        case .international(let name):
            name
        }
    }
}
