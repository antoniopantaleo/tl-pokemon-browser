//
//  Pokemon_BrowserApp.swift
//  Pokemon Browser
//
//  Created by Antonio on 25/04/25.
//

import SwiftUI
import Pokespeare

@main
struct Pokemon_BrowserApp: App {
    
    var body: some Scene {
        WindowGroup {
            let httpClient = URLSessionHTTPClient(session: .shared)
            let pokemonDescriptor = ShakespeareanPokemonDescriptor(client: httpClient)
            let pokemonSpriteLoader = RemotePokemonSpriteLoader(client: httpClient)
            ContentView(
                viewModel: ViewModel(
                    pokemonDescriptor: pokemonDescriptor,
                    pokemonSpriteLoader: pokemonSpriteLoader
                )
            )
        }
    }
}
