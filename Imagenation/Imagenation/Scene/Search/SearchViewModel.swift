//
//  SearchViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 04.09.24.
//

import Foundation

class SearchViewModel {
    var topics = [Topic]()
    var photos = [Photo]()
    var page = 1

    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    let topicManager = TopicManager()
    let discoverManager = DiscoverManager()
    
    func getTopics() {
            topicManager.getTopics() { data, errorMessage in
                if let errorMessage {
                    self.error?(errorMessage)
                } else if let data {
                    self.topics.append(contentsOf: data)
                    self.success?()
                }
            }
    }
    
    func getPhotos() {
        discoverManager.getPhotos(page: page) { data, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                self.photos.append(contentsOf: data)
                self.success?()
            }
        }
    }
    

    func pagination(index: Int) {
        if index == photos.count - 2 {
            page += 1
            getPhotos()
        }
    }
}
