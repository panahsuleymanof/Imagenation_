//
//  PhotoEndpoint.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 26.08.24.
//

import Foundation

enum PhotoEndpoint {
    case photo(id: String)
    
    var path: String {
        switch self {
        case .photo(let id):
            return "topics/\(id)/photos"
        }
    }
}
