//
//  Recipe.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/21/24.
//

import Foundation

struct Recipe: Decodable {
    var id: String
    var name: String
    var category: String
    var cuisine: String
    var instructions: String
    var imageURL: URL
    var ingredient1: String
    
    struct Ingredient {
        var ingredient: String
        var quantity: String
    }
    
    enum RecipeCodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case cuisine = "strArea"
        case instructions = "strInstructions"
        case imageUrl = "strMealThumb"
        case ingredient = "strIngredient1"
    }
    
    enum RootCodingKeys: String, CodingKey {
        case meals
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        var arrayContainer = try rootContainer.nestedUnkeyedContainer(forKey: .meals)
        
        let propertiesContainer = try arrayContainer.nestedContainer(keyedBy: RecipeCodingKeys.self)
        self.id = try propertiesContainer.decode(String.self, forKey: .id)
        self.name = try propertiesContainer.decode(String.self, forKey: .name)
        self.category = try propertiesContainer.decode(String.self, forKey: .category)
        self.cuisine = try propertiesContainer.decode(String.self, forKey: .cuisine)
        self.instructions = try propertiesContainer.decode(String.self, forKey: .instructions)
        self.imageURL = try propertiesContainer.decode(URL.self, forKey: .imageUrl)
        self.ingredient1 = try propertiesContainer.decode(String.self, forKey: .ingredient)
    }
}

Task {
    let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=52893")
    
    let (data, response) = try await URLSession.shared.data(from: url!)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        print("UGH")
        return
    }
    
    let decoder = JSONDecoder()
    let abc = try decoder.decode(Recipe.self, from: data)
    print(abc)
}
