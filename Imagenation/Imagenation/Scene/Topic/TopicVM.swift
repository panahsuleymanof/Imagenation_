//
//  TopicViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import Foundation

class TopicVM {
    var photos = [Photo]()
    var page = 1
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    let photoManager = PhotoManager()
    
    func getPhotos(topicID: String) {
        photoManager.getPhotos(page: page, id: topicID) { [weak self] data, errorMessage in
            if let errorMessage {
                self?.error?(errorMessage)
            } else if let data {
                self?.photos.append(contentsOf: data)
                self?.success?()
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
