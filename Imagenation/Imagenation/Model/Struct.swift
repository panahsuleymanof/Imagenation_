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
    let user: User
    let width, height: Int?
}

struct User: Codable {
    let name: String
}


struct Urls: Codable {
    let small: String
    let regular: String
    let raw: String
}

struct Topic: Codable {
    let id: String
    let title: String
    let cover_photo: CoverInformation
    
    struct CoverInformation: Codable {
        let urls: Urls
    }
}

struct UserInfo: Codable {
    let firstName: String
    let lastName: String
    let username: String
    let email: String
}

struct SearchResult: Codable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
}

struct Collection: Codable {
    let id, title: String?
    let total_photos: Int?
    let user: User?
    let preview_photos: [PreviewPhoto]?
}

struct PreviewPhoto: Codable {
    let id, slug: String?
    let urls: Urls?
}
