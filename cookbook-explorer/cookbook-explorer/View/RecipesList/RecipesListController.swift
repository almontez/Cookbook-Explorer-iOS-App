//
//  RecipesListController.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/21/24.
//

import UIKit

class RecipesListController: UICollectionViewController {
    
    var dataSource: DataSource!
    let networkManager = NetworkManager()
    var recipes = [Recipe]()
    
    init() {
        let layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Desserts"
        Task {
            await fetchRecipes()
            applySnapshot()
        }
        createDataSource()
    }
    
    func fetchRecipes() async {
        do {
            let recipesListRequest = RecipesAPIRequest(url: URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!)
            let recipesData = try await networkManager.fetchData(for: recipesListRequest)
            self.recipes = recipesData.recipes
        } catch {
            // TODO: Create custom error view
            print("Error: \(error.localizedDescription)")
        }
    }
}
