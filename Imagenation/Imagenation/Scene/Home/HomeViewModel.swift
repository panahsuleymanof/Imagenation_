//
//  HomeViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 14.08.24.
//

import Foundation

class HomeViewModel {
    var topics = [Topic]()
    var photos = [Photo]()
    var page = 1
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    let topicManager = TopicManager()
    let photoManager = PhotoManager()
    
    func getTopics() {
//        for page in 1...2 {
            topicManager.getTopics(page: page) { data, errorMessage in
                if let errorMessage {
                    self.error?(errorMessage)
                } else if let data {
                    self.topics.append(contentsOf: data)
                    self.success?()
                    self.getPhotos(topicID: data.first?.id ?? "")
                }
            }
//        }
    }
    
    func getPhotos(topicID: String, isFromTopic: Bool = false) {
        photoManager.getPhotos(page: page, id: topicID) { data, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                if isFromTopic {
                    self.photos.removeAll()
                }
                self.photos.append(contentsOf: data)
                self.success?()
            }
        }
    }
    
    func pagination(index: Int, id: String) {
        print("index: \(index) and count: \(photos.count) and page: \(page)")
        if index == photos.count - 1 && page <= 1500 {
            page += 1
            getPhotos(topicID: id)
        }
    }
}
