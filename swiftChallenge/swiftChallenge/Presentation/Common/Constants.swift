//
//  Constants.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 04/01/2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case generic(Error)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
            case .generic(let error): return error.localizedDescription
            case .invalidResponse: return ""
        }
    }
}

struct Constants {
    static let mockDataBaseUrl = "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
}

enum Orientation {
    case portrait
    case landscape
}

