//
//  RemoteTranslationResponse.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation

struct RemoteTranslationResponse: Decodable {
    struct Contents: Decodable {
        let translated: String
    }
    
    let contents: Contents
}
