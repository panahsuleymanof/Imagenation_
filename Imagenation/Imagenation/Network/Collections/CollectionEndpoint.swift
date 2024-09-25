//
//  CollectionEndpoint.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import Foundation

enum CollectionEndpoint: String {
    case collections = "/collections"
    case searchCollections = "/search/collections"
}

enum CollectionPhotoEndpoint {
    case photo(id: String)
    
    var path: String {
        switch self {
        case .photo(let id):
            return "collections/\(id)/photos"
        }
    }

}
