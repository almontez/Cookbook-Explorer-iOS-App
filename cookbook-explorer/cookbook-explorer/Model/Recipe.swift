//
//  Recipe.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/21/24.
//

import Foundation

struct Recipe {
    var id: String
    var name: String
    var imageURL: String
    var category: String?
    var cuisine: String?
    var instructions: String?
    var tags: String?
    var ingredients: [Ingredient] = []
    
    struct Ingredient {
        var name: String
        var quantity: String
        var quantityInGrams: String {
            return String(quantity.split(separator: "/")[0])
        }
        var quantityInOz: String {
            return String(quantity.split(separator: "/")[1])
        }
    }
}
