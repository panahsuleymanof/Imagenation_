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
    let photoManager = PhotoManager()
    
    func getTopics() {
            topicManager.getTopics(page: page) { data, errorMessage in
                if let errorMessage {
                    self.error?(errorMessage)
                } else if let data {
                    self.topics.append(contentsOf: data)
                    self.success?()
                }
            }
    }
    
    func getPhotos(topicID: String) {
        photoManager.getPhotos(page: page, id: topicID) { data, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                self.photos.append(contentsOf: data)
                self.success?()
            }
        }
    }
}
