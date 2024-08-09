//
//  LoginController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 31.07.24.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailFieldView: UIView!
    @IBOutlet weak var pswdField: UITextField!
    @IBOutlet weak var pswdFieldView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleDesing()
        textFieldDesign()
    }
    func titleDesing() {
        self.title = "Login"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    func textFieldDesign() {
        emailField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        pswdField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
}

