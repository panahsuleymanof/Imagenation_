//
//  CollectionViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import Foundation

class CollectionViewModel {
    var collections = [Collection]()
    var page = 1
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    let collectionManager = CollectionManager()
    
    func getCollections() {
        collectionManager.getCollections(page: page) { data, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                self.collections.append(contentsOf: data)
                self.success?()
            }
        }
    }
    
    func pagination(index: Int) {
        if index == collections.count - 1 && page <= 73 {
            page += 1
            getCollections()
        }
    }
}
