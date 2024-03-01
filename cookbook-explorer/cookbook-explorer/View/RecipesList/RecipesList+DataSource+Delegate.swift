//
//  RecipesList+DataSource+Delegate.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/29/24.
//

import UIKit

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
