//
//  ProfileViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 11.09.24.
//

import Foundation

class ProfileVM {
    var photos = [Photo]()
    var likedPhotos = [String]()
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    let discoverManager = DiscoverManager()

    func getIds(email: String) {
        FirebaseManager.shared.getLikedPhotos(forUserEmail: email) { [weak self] data in
            self?.likedPhotos = data
            self?.photos.removeAll()
            self?.getPhotosByIds(photoIds: data)
            self?.reloadUI()
        }
    }

    func getPhotosByIds(photoIds: [String]) {
        photos.removeAll()
        let dispatchGroup = DispatchGroup()
        
        for id in photoIds {
            dispatchGroup.enter()
            
            discoverManager.getPhotoById(photoId: id) { [weak self] photo, errorMessage in
                guard let self = self else { return }
                
                if let photo = photo {
                    self.photos.append(photo)
                } else {
                    print("Error fetching photo with ID \(id): \(errorMessage ?? "Unknown error")")
                    self.error?(errorMessage ?? "An error occurred")
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if self.photos.isEmpty {
                self.error?("No photos found.")
            } else {
                self.success?()
            }
        }
    }
    
    func reloadUI() {
        print("Liked photo ids are: \(likedPhotos) and photo is \(photos)")
    }
}
