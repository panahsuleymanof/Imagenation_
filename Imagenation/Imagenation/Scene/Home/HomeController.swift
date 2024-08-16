//
//  HomeController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 14.08.24.
//

import UIKit

class HomeController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home Page"
        viewModel.getPhotos()
    }
}
