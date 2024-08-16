//
//  RandomPhoto.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 16.08.24.
//

import Foundation

struct RandomPhoto: Codable {
    let id: String
    let description: String?
    let urls: PhotoURLs
}

struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    let small_s3: String
}
