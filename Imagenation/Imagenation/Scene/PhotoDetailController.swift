//
//  PhotoDetailController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import UIKit
import Kingfisher

class PhotoDetailController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
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
}
