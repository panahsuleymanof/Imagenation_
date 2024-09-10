//
//  PhotoDetailViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import Foundation

class PhotoDetailViewModel {
    let firebaseManager = FirebaseManager.shared
    
    // Check if the photo is liked
    func isPhotoLiked(forUserEmail email: String, photoId: String, completion: @escaping (Bool) -> Void) {
        firebaseManager.isPhotoLiked(forUserEmail: email, photoId: photoId, completion: completion)
    }
    
    // Toggle like/dislike status
    func toggleLikeStatus(forUserEmail email: String, photoId: String, completion: @escaping (Bool) -> Void) {
        firebaseManager.isPhotoLiked(forUserEmail: email, photoId: photoId) { isLiked in
            if isLiked {
                // Dislike the photo if it is currently liked
                self.firebaseManager.dislikePhoto(forUserEmail: email, photoId: photoId) { result in
                    if case .success = result {
                        completion(false)  // Photo is now disliked
                    }
                }
            } else {
                // Like the photo if it is currently not liked
                self.firebaseManager.likePhoto(forUserEmail: email, photoId: photoId) { result in
                    if case .success = result {
                        completion(true)  // Photo is now liked
                    }
                }
            }
        }
    }
}
