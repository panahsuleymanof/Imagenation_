//
//  DIscoverManager.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 06.09.24.
//

import Foundation

protocol DiscoverManagerProtocol {
    func getPhotos(page: Int, completion: @escaping(([Photo]?, String?) -> Void))
    func getPhotoById(photoId: String, completion: @escaping((Photo?, String?) -> Void))
    func searchPhotos(query: String, page: Int ,completion: @escaping((SearchPhoto?, String?) -> Void))
}

class DiscoverManager: DiscoverManagerProtocol {
    func getPhotos(page: Int, completion: @escaping (([Photo]?, String?) -> Void)) {
        let parameters: [String: Int] = ["page": page,
                                         "per_page": 20]
        let endpoint = DiscoverEndpoint.photos.rawValue
        NetworkManager.request(model: [Photo].self, endpoint: endpoint, parameters: parameters, completion: completion)
    }
    
    func getPhotoById(photoId: String, completion: @escaping ((Photo?, String?) -> Void)) {
        let endpoint = "photos/\(photoId)"
        NetworkManager.request(model: Photo.self, endpoint: endpoint) { photo, errorMessage in
            completion(photo, errorMessage)
        }
    }
    
    func searchPhotos(query: String, page: Int, completion: @escaping ((SearchPhoto?, String?) -> Void)) {
        let parameters: [String:Any] = ["query": query,
                                        "page": page,
                                        "per_page": 20
        ]
        let endpoint = DiscoverEndpoint.searchPhotos.rawValue
        NetworkManager.request(model: SearchPhoto.self, endpoint: endpoint, parameters: parameters, completion: completion)
    }
}
