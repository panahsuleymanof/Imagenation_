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
    var userEmail = UserDefaults.standard.string(forKey: "email")

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: photoURL ?? "") {
            image.kf.setImage(with: url)
        }
        if let author = username {
            title = author
        }
        
        if let photoId = photoId {
            viewModel.isPhotoLiked(forUserEmail: userEmail ?? "", photoId: photoId) { isLiked in
                DispatchQueue.main.async {
                    self.updateLikeButton(isLiked: isLiked)
                }
            }
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        guard let photoId = photoId else { return }
        
        // Toggle like/dislike
        viewModel.toggleLikeStatus(forUserEmail: userEmail ?? "", photoId: photoId) { [weak self] isLiked in
            DispatchQueue.main.async {
                self?.updateLikeButton(isLiked: isLiked)
            }
        }
    }
    
    private func updateLikeButton(isLiked: Bool) {
        likeButton.configuration?.baseForegroundColor = isLiked ? .red : .white
    }
}
