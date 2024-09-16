//
//  ProfileController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 04.09.24.
//

import UIKit

class ProfileController: UIViewController {
    @IBOutlet weak var fullName: UILabel!
    
    let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullName.text = UserDefaults.standard.string(forKey: "fullName")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViewModel()
    }
    func configureViewModel() {
        if let email = UserDefaults.standard.string(forKey: "email") {
            viewModel.getIds(email: email)
        }
    }
}
