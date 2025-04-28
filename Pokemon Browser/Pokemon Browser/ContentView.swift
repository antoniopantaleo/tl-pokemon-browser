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
    @State private var spinningAnimation = false
    @State private var isShowingErrorAlert = false
    @Namespace private var card
    
    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(Color.red.opacity(0.7).gradient)
                    .ignoresSafeArea(.all, edges: .all)
                VStack {
                    switch viewModel.state {
                        case _ where isSearching:
                            EmptyView()
                        case .idle:
                            ContentUnavailableView(
                                "Search for a Pokemon",
                                systemImage: "magnifyingglass",
                                description: Text("Enter a Pokemon name to search")
                            )
                        case let .found(description, spriteData):
                            if let uiImage = UIImage(data: spriteData) {
                                PokemonView(
                                    sprite: Image(uiImage: uiImage),
                                    description: description
                                )
                                .rotation3DEffect(
                                    .degrees(spinningAnimation ? 360 : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .matchedGeometryEffect(
                                    id: "card",
                                    in: card,
                                    properties: [.size, .frame, .position],
                                    anchor: .center
                                )
                                .onTapGesture {
                                    withAnimation(.bouncy.speed(0.5)) {
                                        spinningAnimation.toggle()
                                    }
                                }
                            }
                        case .loading:
                            PokemonView(
                                sprite: Image(systemName: "photo"),
                                description: "Lorem ipsum dolor sit amet."
                            )
                            .matchedGeometryEffect(
                                id: "card",
                                in: card,
                                properties: [.size, .frame, .position],
                                anchor: .center,
                                isSource: true
                            )
                            .redacted(reason: .placeholder)
                            .overlay { ProgressView() }
                        case let .notFound(searchedQuery):
                            ContentUnavailableView(
                                "No pokemon named \(searchedQuery) can be found",
                                systemImage: "exclamationmark.triangle.fill",
                                description: Text("Try searching again")
                            )
                        default: EmptyView()
                    }
                }
                .padding(20)
            }
            .animation(.bouncy.speed(0.8), value: viewModel.state)
            .sensoryFeedback(.impact, trigger: spinningAnimation)
            .navigationTitle("Pokemon Browser")
            .searchable(
                text: $viewModel.searchText,
                isPresented: $isSearching,
                prompt: "Pikachu, Bulbasaur, Squirtle, ..."
            )
            .disabled(viewModel.isLoading)
            .onSubmit(of: .search) {
                viewModel.search()
                isSearching = false
            }
            .onChange(of: viewModel.state) { _, newValue in
                guard case .searchFailed = newValue else { return }
                isShowingErrorAlert = true
            }
            .alert(
                "Error",
                isPresented: $isShowingErrorAlert,
                presenting: viewModel.errorMessage,
                actions: { _ in
                    Button("Ok") { }
                },
                message: { Text($0) }
            )
        }
    }
}

#if DEBUG
#Preview {
    ContentView(
        viewModel: ViewModel(
            browser: PreviewPokemonBrowser(
                description: "A description of a pokemon"
            )
        )
    )
}
#endif
