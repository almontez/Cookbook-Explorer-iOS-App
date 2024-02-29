//
//  RecipesListController.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/21/24.
//

import UIKit

class RecipesListController: UIViewController {
    
    var collectionView: UICollectionView!
    var dataSource: DataSource!
    
    let networkManager = NetworkManager()
    var recipes = [Recipe]()
    
    override func loadView() {
        let layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        
        self.view = collectionView
    }
    
    override func viewDidLoad() {
        Task {
            do {
                let recipesListRequest = RecipesAPIRequest(url: URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!)
                let recipesData = try await networkManager.fetchData(for: recipesListRequest)
                recipes = recipesData.recipes
                applySnapshot()
            } catch {
                // TODO: Create custom error view
                print("Error: \(error.localizedDescription)")
            }
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
extension RecipesListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recipe = dataSource.itemIdentifier(for: indexPath) else { return }
        let recipeDetailsController = RecipeDetailsController(recipe: recipe)
        navigationController?.pushViewController(recipeDetailsController, animated: true)
    }
}
