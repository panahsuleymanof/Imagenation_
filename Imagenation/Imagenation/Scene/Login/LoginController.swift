//
//  LoginController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 31.07.24.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailFieldView: UIView!
    @IBOutlet weak var pswdField: UITextField!
    @IBOutlet weak var pswdFieldView: UIView!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        pswdField.delegate = self
        configureTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setChangableColor(textfield: emailField, view: emailFieldView, color: .lightGray)
        setChangableColor(textfield: pswdField, view: pswdFieldView, color: .lightGray)
    }
    
    func configureTitle() {
        self.title = "Login"
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
        if textField == emailField {
            setChangableColor(textfield: textField, view: emailFieldView, color: color)
        } else {
            setChangableColor(textfield: textField, view: pswdFieldView, color: color)
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
    
    @IBAction func logInTapped(_ sender: Any) {
        
    }
    
    @IBAction func joinTapped(_ sender: Any) {
        let coordinator = LoginCoordinator(navigationController: self.navigationController ?? UINavigationController())
        coordinator.start()
    }
}

