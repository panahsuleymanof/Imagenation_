//
//  ProfileViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 11.09.24.
//

import Foundation

class ProfileViewModel {
    var photos = [Photo]()
    var likedPhotos = [String]()
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    let firebaseManager = FirebaseManager.shared
    let discoverManager = DiscoverManager()

    func getIds(email: String) {
        firebaseManager.getLikedPhotos(forUserEmail: email) { data in
            self.likedPhotos = data
            self.reloadUI()
        }
    }

    func getPhotosById(id: [String]) {
        discoverManager.getPhotosById(photoId: id) { data, errorMessage in
            
        }
    }
    
    func reloadUI() {
        print("Liked photo ids are: \(likedPhotos) and photo is \(photos)")
    }
}
