//
//  RandomPhoto.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 16.08.24.
//

import Foundation

struct Photo: Codable {
    let id, slug: String
    let urls: Urls
    let user: User
    let width, height: Int?
    let altDescription: String
    
    enum CodingKeys: String, CodingKey {
        case id, slug
        case urls
        case user
        case width, height
        case altDescription = "alt_description"
    }
}

struct User: Codable {
    let name: String?
}


struct Urls: Codable {
    let small: String
    let regular: String
    let raw: String
}

struct Topic: Codable {
    let id: String
    let title: String
    let coverPhoto: CoverInformation
    
    struct CoverInformation: Codable {
        let urls: Urls
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case coverPhoto = "cover_photo"
    }
}

struct UserInfo: Codable {
    let firstName: String
    let lastName: String
    let username: String
    let email: String
}

struct SearchPhoto: Codable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct SearchCollection: Codable {
    let total: Int
    let totalPages: Int
    let results: [Collection]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct Collection: Codable {
    let id, title: String?
    let totalPhotos: Int?
    let user: User?
    let previewPhotos: [PreviewPhoto]?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case totalPhotos = "total_photos"
        case user
        case previewPhotos = "preview_photos"
    }
}

struct PreviewPhoto: Codable {
    let id, slug: String?
    let urls: Urls?
}
