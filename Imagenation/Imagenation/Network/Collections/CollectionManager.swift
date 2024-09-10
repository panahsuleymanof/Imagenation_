//
//  CollectionManager.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import Foundation

class CollectionManager {
    func getCollections(page: Int, completion: @escaping(([Collection]?, String?) -> Void)) {
        let parameters: [String: Int] = ["page": page,
                                         "per_page": 20]
        let endpoint = CollectionEndpoint.collections.rawValue
        NetworkManager.request(model: [Collection].self, endpoint: endpoint, parameters: parameters ,completion: completion)
    }
    
    func getPhotos(page: Int, id: String, completion: @escaping (([Photo]?, String?) -> Void)) {
        let parameters: [String: Int] = ["page": page,
                                         "per_page": 20]
        NetworkManager.request(model: [Photo].self,
                               endpoint: CollectionPhotoEndpoint.photo(id: id).path,
                               parameters: parameters,
                               completion: completion)
    }
}
