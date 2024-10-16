//
//  PhotoDetailViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import Foundation

class PhotoDetailVM {
    
    func isPhotoLiked(forUserEmail email: String, photoId: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.shared.isPhotoLiked(forUserEmail: email, photoId: photoId, completion: completion)
    }
    
    func toggleLikeStatus(forUserEmail email: String, photoId: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.shared.isPhotoLiked(forUserEmail: email, photoId: photoId) { isLiked in
            if isLiked {
                FirebaseManager.shared.dislikePhoto(forUserEmail: email, photoId: photoId) { result in
                    if case .success = result {
                        completion(false)
                    }
                }
            } else {
                FirebaseManager.shared.likePhoto(forUserEmail: email, photoId: photoId) { result in
                    if case .success = result {
                        completion(true)
                    }
                }
            }
        }
    }
}
