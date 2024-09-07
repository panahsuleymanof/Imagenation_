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
    var searchQuery: String?

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
    
    func searchPhotos(query: String) {
        self.searchQuery = query // Store the current search query
        self.page = 1            // Reset pagination for search
        self.photos.removeAll()
        
        discoverManager.searchPhotos(query: query, page: page) { data, errorMessage in
            if let errorMessage = errorMessage {
                self.error?(errorMessage)
            } else if let data = data {
                self.photos = data
                self.success?()
            }
        }
    }
    
    func pagination(index: Int) {
        if index == photos.count - 2 {
            page += 1

            if let query = searchQuery, !query.isEmpty {
                // Perform pagination for search results
                discoverManager.searchPhotos(query: query, page: page) { data, errorMessage in
                    if let errorMessage = errorMessage {
                        self.error?(errorMessage)
                    } else if let data = data {
                        self.photos.append(contentsOf: data)
                        self.success?()
                    }
                }
            } else {
                // Perform pagination for default photos
                getPhotos()
            }
        }
    }

    func resetSearch() {
        self.searchQuery = nil
        self.page = 1
        self.photos.removeAll()
        getPhotos() // Load default photos
    }
}
