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
    typealias sectionItem = Section.SectionItem
    typealias section = Section.SectionName
    typealias DataSource = UICollectionViewDiffableDataSource<section, sectionItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<section, sectionItem>
    
    func createDataSource() {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: sectionItem) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, item: sectionItem) {
        var contentConfiguration = cell.defaultContentConfiguration()
        
        switch item {
        case .title(let text): 
            contentConfiguration.text = text
        case .ingredient(let ingredient): 
            contentConfiguration.prefersSideBySideTextAndSecondaryText = true
            contentConfiguration.text = ingredient.quantity
            contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
            contentConfiguration.secondaryText = ingredient.name
            contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .body)
        case .instruction(let text):
            contentConfiguration.text = text
        }
        
        cell.contentConfiguration = contentConfiguration
    }
        
    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.recipeName, .ingredients, .instructions])
        
        snapshot.appendItems([sectionItem.title(recipe.name)], toSection: .recipeName)
        snapshot.appendItems([sectionItem.instruction(recipe.instructions!)], toSection: .instructions)
        
        recipe.ingredients.forEach { (ingredient) in
            snapshot.appendItems([sectionItem.ingredient(ingredient)], toSection: .ingredients)
        }
        
        dataSource.apply(snapshot)
    }
}
