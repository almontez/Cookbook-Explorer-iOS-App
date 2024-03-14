//
//  RecipeDecoder.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/22/24.
//

import Foundation

extension Recipe: Decodable {
    
    struct DynamicCodingKey: CodingKey {

        // Use for string based dictionary
        var stringValue: String
        init(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            // Not using intger values
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        
        // non-optional properties
        self.id = try container.decode(String.self, forKey: DynamicCodingKey(stringValue: "idMeal"))
        self.name = try container.decode(String.self, forKey: DynamicCodingKey(stringValue: "strMeal"))
        self.imageURL = try container.decode(String.self, forKey: DynamicCodingKey(stringValue: "strMealThumb"))
        
        // optional properties
        self.category = try container.decodeIfPresent(String.self, forKey: DynamicCodingKey(stringValue: "strCategory"))
        self.cuisine = try container.decodeIfPresent(String.self, forKey: DynamicCodingKey(stringValue: "strArea"))
        self.instructions = try container.decodeIfPresent(String.self, forKey: DynamicCodingKey(stringValue: "strInstructions"))
        self.tags = try container.decodeIfPresent(String.self, forKey: DynamicCodingKey(stringValue: "stringTags"))
        
        // ingredients list
        var i = 1
        while
            let name = try container.decodeIfPresent(String.self, forKey: DynamicCodingKey(stringValue: "strIngredient\(i)")),
            let amount = try container.decodeIfPresent(String.self, forKey: DynamicCodingKey(stringValue: "strMeasure\(i)")),
            !name.isEmpty, !amount.isEmpty
        {
            self.ingredients.append(Ingredient(name: name, quantity: amount))
            i += 1
        }
    }
}
