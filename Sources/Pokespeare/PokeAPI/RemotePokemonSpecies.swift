//
//  RemotePokemonSpecies.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation

struct RemotePokemonSpecies: Decodable {
    struct FlavorTextEntry: Decodable {
        struct Language: Decodable {
            let name: String
        }
        let flavor_text: String
        let language: Language
    }
    let flavor_text_entries: [FlavorTextEntry]
}
