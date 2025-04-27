//
//  Preview Helpers.swift
//  Pokemon Browser
//
//  Created by Antonio on 26/04/25.
//

#if DEBUG
import Foundation
import Pokespeare
import UIKit

extension UIImage {
    static func from(
        color: UIColor,
        size: CGSize = CGSize(
            width: 100,
            height: 100
        )
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}

struct PreviewPokemonBrowser: PokemonBrowser {
    
    private let description: String
    
    init(description: String) {
        self.description = description
    }
    
    func search(pokemonName: String) async throws -> (description: String,spriteData: Data) {
        (description, UIImage.from(color: .red).pngData()!)
    }
}
#endif
