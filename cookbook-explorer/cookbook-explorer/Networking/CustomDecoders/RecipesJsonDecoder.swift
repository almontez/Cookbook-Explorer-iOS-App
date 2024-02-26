//
//  RecipesJsonDecoder.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/22/24.
//

import Foundation

struct RecipesJson: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case meals
    }
    
    private(set) var recipes: [Recipe] = []
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        var mealsArrayContainer = try rootContainer.nestedUnkeyedContainer(forKey: .meals)
        while !mealsArrayContainer.isAtEnd {
            let recipe = try mealsArrayContainer.decode(Recipe.self)
            self.recipes.append(recipe)
        }
    }
}
