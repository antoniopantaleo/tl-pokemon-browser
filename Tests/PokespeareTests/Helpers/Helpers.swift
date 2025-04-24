//
//  Helpers.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation

var anyURL: URL { URL(string: "https://example.com")! }
var anyData: Data { Data("any-data".utf8) }

func makePokemonDetailResponseData(
    id: Int,
    name: String,
    spriteURL: URL?
) throws -> Data {
    var dict: [String: Any] = [
        "id": id,
        "name": name,
        "sprites": [:]
    ]
    if let spriteURL {
        dict["sprites"] = ["front_default": spriteURL.absoluteString]
    }
    return try JSONSerialization.data(withJSONObject: dict)
}
