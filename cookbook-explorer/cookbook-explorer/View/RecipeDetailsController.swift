//
//  RecipeDetailsController.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/29/24.
//

import UIKit

class RecipeDetailsController: UIViewController {
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. use init(recipe:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HERE I AM")
    }

}
