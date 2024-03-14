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
            await fetchRecipesList()
            applySnapshot()
        }
        createDataSource()
    }
}

// MARK: - DiffableDataSource
extension RecipesListController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Recipe>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Recipe>
    
    enum Section {
        case main
    }
    
    func createDataSource() {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, recipe: Recipe) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: recipe)
        }
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, recipe: Recipe) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = recipe.name
        cell.contentConfiguration = contentConfiguration
        cell.accessories = [.disclosureIndicator()]
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(recipes)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension RecipesListController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recipe = dataSource.itemIdentifier(for: indexPath) else { return }
        Task {
            let updatedRecipe = await fetchRecipeData(for: recipe)
            let recipeDetailsController = RecipeDetailsController(recipe: updatedRecipe)
            navigationController?.pushViewController(recipeDetailsController, animated: true)
        }
    }
}

// MARK: - Networking Code
extension RecipesListController {
    func fetchRecipesList() async {
        do {
            let recipesListRequest = RecipesAPIRequest(url: URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!)
            let recipesData = try await networkManager.fetchData(for: recipesListRequest)
            self.recipes = recipesData.recipes
        } catch {
            // TODO: Create custom error view
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func fetchRecipeData(for recipe: Recipe) async -> Recipe {
        var updatedRecipe = recipe
        do {
            let recipeDataRequest = RecipesAPIRequest(url: URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(recipe.id)")!)
            let recipeData = try await networkManager.fetchData(for: recipeDataRequest)
            updatedRecipe = recipeData.recipes[0]
        } catch {
            print(error.localizedDescription)
        }
        return updatedRecipe
    }
}
