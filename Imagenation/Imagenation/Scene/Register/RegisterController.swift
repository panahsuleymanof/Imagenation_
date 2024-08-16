//
//  RegisterController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 31.07.24.
//

import UIKit

class RegisterController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var pswdField: UITextField!
    @IBOutlet weak var pswdView: UIView!
    
    let viewModel = RegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle()
        firstNameField.delegate = self
        lastNameField.delegate = self
        usernameField.delegate = self
        emailField.delegate = self
        pswdField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setChangableColor(textfield: firstNameField, view: firstNameView, color: .lightGray)
        setChangableColor(textfield: lastNameField, view: lastNameView, color: .lightGray)
        setChangableColor(textfield: usernameField, view: usernameView, color: .lightGray)
        setChangableColor(textfield: emailField, view: emailView, color: .lightGray)
        setChangableColor(textfield: pswdField, view: pswdView, color: .lightGray)
    }
    
    func configureTitle() {
        self.title = "Join Imagenation"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateColor(textField: textField, color: .white)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateColor(textField: textField, color: .lightGray)
    }
    
    func updateColor(textField: UITextField, color: UIColor) {
        if textField == firstNameField {
            setChangableColor(textfield: textField, view: firstNameView, color: color)
        } else if textField == lastNameField {
            setChangableColor(textfield: textField, view: lastNameView, color: color)
        } else if textField == usernameField {
            setChangableColor(textfield: textField, view: usernameView, color: color)
        } else if textField == emailField {
            setChangableColor(textfield: textField, view: emailView, color: color)
        } else {
            setChangableColor(textfield: textField, view: pswdView, color: color)
        }
    }
        
    func setChangableColor(textfield: UITextField, view: UIView,color: UIColor) {
        if let placeholder = textfield.placeholder {
            textfield.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: color])
            view.backgroundColor = color
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let coordinator = LoginCoordinator(navigationController: self.navigationController ?? UINavigationController())
        coordinator.back()
    }
}
