//
//  SearchViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 04.09.24.
//

import Foundation

class SearchVM {
    var topics = [Topic]()
    var photos = [Photo]()
    var searchedPhotos = [Photo]()
    
    var page = 1
    var searchPage = 1
    
    var isSearching = false
    var isLoading = false

    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    let topicManager = TopicManager()
    let discoverManager = DiscoverManager()
    
    func getTopics() {
            topicManager.getTopics() { [weak self] data, errorMessage in
                if let errorMessage {
                    self?.error?(errorMessage)
                } else if let data {
                    self?.topics.append(contentsOf: data)
                    self?.success?()
                }
            }
    }
    
    func getPhotos() {
        guard !isLoading else { return } // Prevent multiple loads
        isLoading = true
        discoverManager.getPhotos(page: page) { [weak self] data, errorMessage in
            self?.isLoading = false
            if let errorMessage {
                self?.error?(errorMessage)
            } else if let data {
                self?.photos.append(contentsOf: data)
                self?.success?()
            }
        }
    }
    
    func getSearchedPhotos(query: String) {
        guard !isLoading else { return } // Prevent multiple loads
        isLoading = true
        discoverManager.searchPhotos(query: query, page: searchPage) { [weak self] data, errorMessage in
            self?.isLoading = false
            if let errorMessage {
                self?.error?(errorMessage)
            } else if let data {
                self?.searchedPhotos.append(contentsOf: data.results)
                self?.success?()
            }
        }
    }
    
    func resetSearch() {
        searchPage = 1
        searchedPhotos.removeAll()
        isSearching = false
    }
    
    func pagination(index: Int, query: String? = nil) {
        if let query = query, isSearching {
            if index == searchedPhotos.count - 2 {
                searchPage += 1
                getSearchedPhotos(query: query)
            }
        } else {
            if index == photos.count - 2 {
                page += 1
                getPhotos()
            }
        }
    }
}
