//
//  RemotePokemonDetail.swift
//  Pokespeare
//
//  Created by Antonio on 23/04/25.
//

import Foundation

struct RemotePokemonDetail: Decodable {
    struct Sprites: Decodable {
        let front_default: URL?
    }
    
    let id: Int
    let name: String
    let sprites: Sprites
}
