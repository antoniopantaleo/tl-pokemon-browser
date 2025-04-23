//
//  PokeAPI.swift
//  Pokespeare
//
//  Created by Antonio on 23/04/25.
//

import Foundation

enum PokeAPI {
    case pokemon(name: String)
    
    var url: URL? {
        guard let base = URL(string: "https://pokeapi.co/api/v2/") else { return nil }
        return switch self {
            case let .pokemon(name):
                base.appending(components: "pokemon", name)
        }
    }
}
