//
//  HomeViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 14.08.24.
//

import Foundation

class HomeViewModel {
    var photoURL = [PhotoURLs]()
    
    func getPhotos() {
        PhotoService.fetchRandomPhoto { photo, errorMessage in
            if let photo {
                self.photoURL.append(photo.urls)
                print(self.photoURL)
            } else if let errorMessage {
                print(errorMessage)
            }
        }
    }
}
