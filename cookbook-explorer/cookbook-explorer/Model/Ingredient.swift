//
//  Ingredient.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 3/13/24.
//

import Foundation

struct Ingredient {
    var name: String
    var quantity: String
}

extension Ingredient: Hashable {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.name == rhs.name && lhs.quantity == rhs.quantity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(quantity)
    }
}
