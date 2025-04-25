//
//  FunTranslationsAPI.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation

enum FunTranslationsAPI {
    case shakespeare(text: String)
    
    var url: URL {
        let base = URL(staticString: "https://api.funtranslations.com/translate")
        return switch self {
            case let .shakespeare(text):
                base
                    .appending(components: "shakespeare.json")
                    .appending(queryItems: ("text", text))
        }
    }
}
