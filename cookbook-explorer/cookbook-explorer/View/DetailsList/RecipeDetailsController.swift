//
//  RecipeDetailsController.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/29/24.
//

import UIKit

class RecipeDetailsController: UICollectionViewController {
    var dataSource: DataSource!
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(recipe:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.allowsSelection = false
        configureNavigationBar()
        createDataSource()
        applySnapshot()
    }
    
    func configureNavigationBar() {
        navigationItem.title = recipe.name
        let whiteAppearance = UINavigationBarAppearance()
        whiteAppearance.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance = whiteAppearance
    }
}

// MARK: - DiffableDataSource
extension RecipeDetailsController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    enum Section {
        case recipeName
        case ingredients
        case instructions
    }
    
    enum Row {
        case recipeName
        case ingredients
        case instructions
    }
    
    func createDataSource() {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, row: Row) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: row)
        }
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        var contentConfiguration = cell.defaultContentConfiguration()
        
        switch row {
        case .recipeName: contentConfiguration.text = recipe.name
        case .ingredients: contentConfiguration.text = text(for: recipe.ingredients)
        case .instructions: contentConfiguration.text = recipe.instructions
        }
        
        cell.contentConfiguration = contentConfiguration
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.recipeName, .ingredients, .instructions])
        snapshot.appendItems([Row.recipeName], toSection: .recipeName)
        snapshot.appendItems([Row.ingredients], toSection: .ingredients)
        snapshot.appendItems([Row.instructions], toSection: .instructions)
        dataSource.apply(snapshot)
    }
    
    func text(for ingredients: [Ingredient]) -> String {
        print(ingredients)
        return "I'm working on it"
    }
}
