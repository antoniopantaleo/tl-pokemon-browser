//
//  PokeAPIPokemonDetail.swift
//  Pokespeare
//
//  Created by Antonio on 23/04/25.
//

import Foundation

struct PokeAPIPokemonDetail: Decodable {
    struct Sprites: Decodable {
        let front_default: URL?
    }
    
    struct Species: Decodable {
        let url: URL
    }
    
    let id: Int
    let name: String
    let species: Species
    let sprites: Sprites
}
