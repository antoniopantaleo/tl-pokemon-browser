//
//  ContentView.swift
//  Pokemon Browser
//
//  Created by Antonio on 25/04/25.
//

import SwiftUI
import Pokespeare

struct ContentView: View {
    
    @State private var viewModel: ViewModel
    @State private var isSearching = false
    
    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(Color.yellow.opacity(0.7).gradient)
                    .ignoresSafeArea(.all, edges: .all)
                VStack {
                    if
                        let description = viewModel.pokemonDescription,
                        let imageData = viewModel.pokemonSprite,
                        let uiImage = UIImage(data: imageData),
                        !isSearching
                    {
                        PokemonView(
                            sprite: Image(uiImage: uiImage),
                            description: description
                        )
                        .padding()
                    } else if !isSearching {
                        ContentUnavailableView(
                            "Search for a Pokemon",
                            systemImage: "magnifyingglass",
                            description: Text("Enter a Pokemon name to search")
                        )
                    }
                }
                .padding()
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            .navigationTitle("Pokemon Browser")
            .searchable(
                text: $viewModel.searchText,
                isPresented: $isSearching,
                prompt: "Search"
            )
            .onSubmit(of: .search) {
                viewModel.search()
                isSearching = false
            }
        }
    }
}

#if DEBUG
#Preview {
    ContentView(
        viewModel: ViewModel(
            pokemonDescriptor: PreviewPokemonDescriptor(description: "A description of a Pokemon"),
            pokemonSpriteLoader: PreviewPokemonSpriteLoader()
        )
    )
}
#endif
