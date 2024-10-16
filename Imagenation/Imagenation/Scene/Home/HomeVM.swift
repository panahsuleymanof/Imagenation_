//
//  HomeViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 14.08.24.
//

import Foundation

class HomeVM {
    var topics = [Topic]()
    var photos = [Photo]()
    var page = 1
    var isTopicsFetched = false
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    let topicManager = TopicManager()
    let photoManager = PhotoManager()
    
    func getTopics() {
        topicManager.getTopics() { [weak self] data, errorMessage in
            if let errorMessage {
                self?.error?(errorMessage)
            } else if let data {
                self?.topics.append(contentsOf: data)
                self?.isTopicsFetched = true
                if let firstTopicID = data.first?.id {
                    self?.getPhotos(topicID: firstTopicID, isFromTopic: true)
                }
                self?.success?()
            }
        }
    }
    
    func getPhotos(topicID: String, isFromTopic: Bool = false) {
        photoManager.getPhotos(page: page, id: topicID) { [weak self] data, errorMessage in
            if let errorMessage {
                self?.error?(errorMessage)
            } else if let data {
                if isFromTopic {
                    self?.photos.removeAll()
                }
                self?.photos.append(contentsOf: data)
                self?.success?()
            }
        }
    }
    
    func pagination(index: Int, id: String) {
        print("index: \(index) and count: \(photos.count) and page: \(page)")
        if index == photos.count - 1 && page <= 1500 {
            page += 1
            getPhotos(topicID: id, isFromTopic: false)
        }
    }
}
