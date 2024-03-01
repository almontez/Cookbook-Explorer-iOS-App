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
        fatalError("init(coder:) has not been implemented. use init(recipe:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.allowsSelection = false
        print(recipe)
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
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Recipe>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Recipe>
    
    enum Section {
        case name
        case ingredients
        case instructions
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
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
    }
}
