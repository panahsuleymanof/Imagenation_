//
//  CollectionViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import Foundation

class CollectionVM {
    var collections = [Collection]()
    var searchedCollections = [Collection]()
    
    var page = 1
    var searchPage = 1
    
    var isSearching = false
    var isLoading = false
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    let collectionManager = CollectionManager()
    
    func getCollections() {
        guard !isLoading else { return } // Prevent multiple loads
        isLoading = true
        collectionManager.getCollections(page: page) { data, errorMessage in
            self.isLoading = false
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                self.collections.append(contentsOf: data)
                self.success?()
            }
        }
    }
    
    func getSearchedCollections(query: String) {
        collectionManager.searchCollection(query: query, page: searchPage) { data, errorMessage in
            self.isLoading = false
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                self.searchedCollections.append(contentsOf: data.results)
                print(self.searchedCollections)
                self.success?()
            }
        }
    }
    
    func resetSearch() {
        searchPage = 1
        searchedCollections.removeAll()
        isSearching = false
    }
    
    func pagination(index: Int, query: String? = nil) {
        if let query = query, isSearching {
            if index == searchedCollections.count - 1 {
                searchPage += 1
                getSearchedCollections(query: query)
            }
        } else {
            if index == collections.count - 1 {
                page += 1
                getCollections()
            }
        }
    }
}
