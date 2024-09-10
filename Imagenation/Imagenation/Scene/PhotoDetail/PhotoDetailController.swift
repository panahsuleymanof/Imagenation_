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
    var altDescription: String?
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
        
        viewModel.toggleLikeStatus(forUserEmail: userEmail ?? "", photoId: photoId) { [weak self] isLiked in
            DispatchQueue.main.async {
                self?.updateLikeButton(isLiked: isLiked)
            }
        }
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "\(InfoController.self)") as! InfoController
        vc.imageDescription = altDescription ?? ""
        navigationController?.modalPresentationStyle = .popover
        navigationController?.present(vc, animated: true)
    }
    
    @IBAction func downloadTapped(_ sender: Any) {
        if let image = image.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            print("Error: No image found in the UIImageView")
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Downloaded!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateLikeButton(isLiked: Bool) {
        likeButton.configuration?.baseForegroundColor = isLiked ? .red : .white
    }
}
