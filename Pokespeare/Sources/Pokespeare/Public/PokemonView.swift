//
//  PokemonView.swift
//  Pokespeare
//
//  Created by Antonio on 25/04/25.
//

import SwiftUI

/// A view that displays a card-style like Pokémon sprite and its description.
public struct PokemonView: View {
    
    private let sprite: Image
    private let description: String
    
    /// Use this method to create a new instance of ``PokemonView`` with a given sprite and description.
    /// - Parameters:
    ///   - sprite: The Pokémon sprite to display.
    ///   - description: The description of the Pokémon.
    public init(sprite: Image, description: String) {
        self.sprite = sprite
        self.description = description
    }
    
    private let shineColors: [Color] = [
        .clear,
        .clear,
        .white.opacity(0.1),
        .white.opacity(0.3),
        .white.opacity(0.5),
        .white,
        .white.opacity(0.5),
        .white.opacity(0.3),
        .white.opacity(0.1),
        .clear,
        .clear
    ]
    
    public var body: some View {
        VStack {
            sprite
                .interpolation(.none)
                .resizable()
                .aspectRatio(1, contentMode: .fit)

            Text(description)
                .font(.title3)
                .fontWeight(.bold)
                .padding()
        }
        .overlay {
            GeometryReader { proxy in
                Rectangle()
                    .fill(
                        .linearGradient(
                            colors: shineColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                .opacity(0.4)
                .scaleEffect(y: 10)
                .rotationEffect(.degrees(45))
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .background {
            RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.clear)
            .shadow(radius: 20, y: 10)
        }
    }
}

#if DEBUG
#Preview {
    PokemonView(
        sprite: Image("demoSprite", bundle: .module),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    )
        .padding()
        .background(.white)
        .frame(width: 400, height: 400)
}
#endif
