//
//  RandomPhoto.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 16.08.24.
//

import Foundation

struct Photo: Codable {
    let id: String
    let urls: Urls
    
    struct Urls: Codable {
        let small: String
        let regular: String
    }
}

struct Topic: Codable {
    let id: String
    let title: String
}
