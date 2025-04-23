//
//  URL+Extension.swift
//  Pokespeare
//
//  Created by Antonio on 23/04/25.
//

import Foundation

extension URL {
    
    /// Creates a URL from a static string that is known at compile time.
    /// - Parameter staticString: The static string to create the URL from.
    ///
    /// If the string cannot be converted to a valid URL, a runtime error will occur.
    /// This is useful for creating URLs that are guaranteed to be valid and do not require dynamic input.
    init(staticString: StaticString) {
        guard let url = URL(string: "\(staticString)") else {
            fatalError("Invalid URL: \(staticString)")
        }
        self = url
    }
}
