//
//  InfoController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 10.09.24.
//

import UIKit

class InfoController: UIViewController {
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    var imageDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageDescription = imageDescription {
            descriptionLabel.text = imageDescription
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
