//
//  CollectionPhotoViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 08.09.24.
//

import Foundation

class CollectionPhotoVM {
    var photos = [Photo]()
    var page = 1
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    let collectionManager = CollectionManager()
    
    func getPhotos(collectionId: String) {
        collectionManager.getPhotos(page: page, id: collectionId) { data, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                self.photos.append(contentsOf: data)
                self.success?()
            }
        }
    }
    
    func pagination(index: Int, id: String) {
        print("index: \(index) and count: \(photos.count) and page: \(page)")
        if index == photos.count - 1 && page <= 1500 {
            page += 1
            getPhotos(collectionId: id)
        }
    }
}
