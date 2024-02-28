//
//  RecipesListController.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/21/24.
//

import UIKit

class RecipesListController: UIViewController {
    
    var collectionView: UICollectionView!
    let networkManager = NetworkManager()
    var recipes = [Recipe]()
    
    override func loadView() {
        let layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .red
        
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "ListCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.view = collectionView
    }
    
    override func viewDidLoad() {
        Task {
            do {
                let recipesListRequest = RecipesAPIRequest(url: URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!)
                let recipesData = try await networkManager.fetchData(for: recipesListRequest)
                recipes = recipesData.recipes
                collectionView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension RecipesListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("HERE I AM")
    }
    
}

extension RecipesListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipe = recipes[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? UICollectionViewListCell else {
            fatalError("Unable to dequeue cell")
        }
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = recipe.name
        cell.contentConfiguration = contentConfiguration
        return cell
    }
}
