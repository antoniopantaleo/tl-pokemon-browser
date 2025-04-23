//
//  PokeAPI.swift
//  Pokespeare
//
//  Created by Antonio on 23/04/25.
//

import Foundation

enum PokeAPI {
    case pokemon(name: String)
    
    var url: URL {
        let base = URL(staticString: "https://pokeapi.co/api/v2/")
        return switch self {
            case let .pokemon(name):
                base.appending(components: "pokemon", name)
        }
    }
}
