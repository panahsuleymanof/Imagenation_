//
//  DIscoverManager.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 06.09.24.
//

import Foundation

protocol DiscoverManagerProtocol {
    func getPhotos(page: Int, completion: @escaping(([Photo]?, String?) -> Void))
    func searchPhotos(query: String, page: Int, completion: @escaping(([Photo]?, String?) -> Void))
}

class DiscoverManager: DiscoverManagerProtocol {
    
    func searchPhotos(query: String, page: Int, completion: @escaping (([Photo]?, String?) -> Void)) {
        let parameters: [String:Any] = ["query": query,
                                        "page": page,
                                        "per_page": 20
        ]
        let endpoint = DiscoverEndpoint.search.rawValue
        NetworkManager.request(model: SearchResult.self, endpoint: endpoint) { result, error in
            completion(result?.results, nil)
        }
    }
    
    func getPhotos(page: Int, completion: @escaping (([Photo]?, String?) -> Void)) {
        let parameters: [String: Int] = ["page": page, 
                                         "per_page": 20]
        let endpoint = DiscoverEndpoint.photos.rawValue
        NetworkManager.request(model: [Photo].self, endpoint: endpoint, parameters: parameters, completion: completion)
    }
}
