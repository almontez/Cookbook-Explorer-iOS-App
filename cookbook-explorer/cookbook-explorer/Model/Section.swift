//
//  Section.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 3/13/24.
//

import Foundation

struct Section {
    
    enum SectionName {
        case recipeName
        case ingredients
        case instructions
    }
    
    enum SectionItem: Hashable {
        case title(String)
        case ingredient(Ingredient)
        case instruction(String)
        
        static func == (lhs: SectionItem, rhs: SectionItem) -> Bool {
            switch (lhs, rhs) {
            case (let .title(lhs), let .title(rhs)): return lhs == rhs
            case (let .ingredient(lhs), let .ingredient(rhs)): return lhs == rhs
            case (let .instruction(lhs), let .instruction(rhs)): return lhs == rhs
            default: return false
            }
        }
    }
    
}
