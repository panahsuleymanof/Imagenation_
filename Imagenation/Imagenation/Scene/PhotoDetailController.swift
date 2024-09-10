//
//  PhotoDetailController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import UIKit
import Kingfisher

class PhotoDetailController: UIViewController {
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    
    let viewModel = PhotoDetailViewModel()
    
    var photoId: String?
    var photoURL: String?
    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: photoURL ?? "") {
            image.kf.setImage(with: url)
        }
        if let author = username {
            title = author
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
//        let unsplashService = UnsplashService()
//        print(photoId ?? "")
//        unsplashService.likePhoto(photoID: photoId ?? "") { result in
//            switch result {
//            case .success(let photo):
//                self.likeButton.backgroundColor = .red
//                print("Photo liked successfully: \(photo.urls.regular), liked by user: \(photo.user.name)")
//            case .failure(let error):
//                print("Failed to like photo: \(error)")
//            }
//        }
    }
}
