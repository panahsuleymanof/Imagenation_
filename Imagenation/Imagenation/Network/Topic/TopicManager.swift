//
//  TopicManager.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 24.08.24.
//

import Foundation

protocol TopicManagerProtocol {
    func getTopics(completion: @escaping(([Topic]?, String?) -> Void))
}

class TopicManager: TopicManagerProtocol {
    func getTopics(completion: @escaping (([Topic]?, String?) -> Void)) {
        let parameters: [String: Int] = ["per_page": 20]
        let endpoint = TopicEndpoint.topics.rawValue
        NetworkManager.request(model: [Topic].self, endpoint: endpoint, parameters: parameters, completion: completion)
    }
}
