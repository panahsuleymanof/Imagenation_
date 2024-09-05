//
//  ProfileController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 04.09.24.
//

import UIKit

class ProfileController: UIViewController {

    @IBOutlet weak var fullName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fullName.text = UserDefaults.standard.string(forKey: "fullName")
    }
}
