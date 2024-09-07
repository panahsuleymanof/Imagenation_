//
//  PhotoManager.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 26.08.24.
//

import Foundation

protocol PhotoManagerProtocol {
    func getPhotos(page: Int, id: String, completion: @escaping(([Photo]?, String?) -> Void))
}

class PhotoManager: PhotoManagerProtocol {
    func getPhotos(page: Int, id: String, completion: @escaping (([Photo]?, String?) -> Void)) {
        let parameters: [String: Int] = ["page": page]
        NetworkManager.request(model: [Photo].self,
                               endpoint: PhotoEndpoint.photo(id: id).path,
                               parameters: parameters,
                               completion: completion)
    }
}
