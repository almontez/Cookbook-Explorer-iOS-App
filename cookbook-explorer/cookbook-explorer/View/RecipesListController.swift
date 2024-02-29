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
        let layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        collectionView.alwaysBounceVertical = true
        // TODO: Update background color to .white!!
        collectionView.backgroundColor = .red
        
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "ListCell")
        
        self.view = collectionView
    }
    
    override func viewDidLoad() {
        Task {
            do {
                let recipesListRequest = RecipesAPIRequest(url: URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!)
                let recipesData = try await networkManager.fetchData(for: recipesListRequest)
                recipes = recipesData.recipes
                createDataSource()
                updateSnapshot()
            } catch {
                // TODO: Create custom error view
                print("Error: \(error.localizedDescription)")
            }
        }
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
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, recipe: Recipe) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? UICollectionViewListCell else {
                fatalError("Unable to dequeue cell")
            }
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = recipe.name
            cell.contentConfiguration = contentConfiguration
            return cell
        }
    }
    
    func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(recipes)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
