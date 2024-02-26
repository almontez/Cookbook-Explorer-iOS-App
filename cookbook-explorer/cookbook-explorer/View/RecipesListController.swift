//
//  RecipesListController.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/21/24.
//

import UIKit

class RecipesListController: UIViewController {
    
    let networkManager = NetworkManager()
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        let recipesListRequest = RecipesAPIRequest(url: url)
        
        Task {
            do {
                let recipesData = try await networkManager.fetchData(for: recipesListRequest)
                print(recipesData.recipes)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}
