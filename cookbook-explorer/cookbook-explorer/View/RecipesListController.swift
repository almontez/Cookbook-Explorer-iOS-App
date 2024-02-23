//
//  RecipesListController.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/21/24.
//

import UIKit

class RecipesListController: UIViewController {
    
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        Task {
            let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")
//            let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=52768")
            
            let (data, response) = try await URLSession.shared.data(from: url!)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("UGH")
                return
            }
            
            let decoder = JSONDecoder()
            let abc = try decoder.decode(RecipesJsonDecoder.self, from: data)
            print(abc)
        }
    }

}
