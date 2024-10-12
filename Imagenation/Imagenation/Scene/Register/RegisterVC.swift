//
//  RegisterController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 31.07.24.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {
    @IBOutlet private weak var firstNameField: UITextField!
    @IBOutlet private weak var firstNameView: UIView!
    @IBOutlet private weak var lastNameField: UITextField!
    @IBOutlet private weak var lastNameView: UIView!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var usernameView: UIView!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var pswdField: UITextField!
    @IBOutlet private weak var pswdView: UIView!
    
    let viewModel = RegisterVM()
    var logInCallBack: ((String, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        configureUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setChangableColor(textfield: firstNameField, view: firstNameView, color: .lightGray)
        setChangableColor(textfield: lastNameField, view: lastNameView, color: .lightGray)
        setChangableColor(textfield: usernameField, view: usernameView, color: .lightGray)
        setChangableColor(textfield: emailField, view: emailView, color: .lightGray)
        setChangableColor(textfield: pswdField, view: pswdView, color: .lightGray)
    }
    
    private func configureUI() {
        title = "Join Imagenation"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        usernameField.delegate = self
        emailField.delegate = self
        pswdField.delegate = self
    }
    
    private func setupBindings() {
        viewModel.registerSuccess = { [weak self] in
            guard let self = self, let email = self.emailField.text, let password = self.pswdField.text else { return }
            self.logInCallBack?(email, password)
            self.navigationController?.popViewController(animated: true)
        }

        viewModel.registerFailed = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showError(message: errorMessage)
            }
        }
    }

    @IBAction func signUpTapped(_ sender: Any) {
        guard let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let username = usernameField.text,
              let email = emailField.text,
              let password = pswdField.text else {
                  return
              }

        viewModel.registerUser(firstName: firstName, lastName: lastName, username: username, email: email, password: password)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateColor(textField: textField, color: .white)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateColor(textField: textField, color: .lightGray)
    }

    private func updateColor(textField: UITextField, color: UIColor) {
        switch textField {
        case firstNameField:
            setChangableColor(textfield: firstNameField, view: firstNameView, color: color)
        case lastNameField:
            setChangableColor(textfield: lastNameField, view: lastNameView, color: color)
        case usernameField:
            setChangableColor(textfield: usernameField, view: usernameView, color: color)
        case emailField:
            setChangableColor(textfield: emailField, view: emailView, color: color)
        case pswdField:
            setChangableColor(textfield: pswdField, view: pswdView, color: color)
        default:
            break
        }
    }

    private func setChangableColor(textfield: UITextField, view: UIView, color: UIColor) {
        if let placeholder = textfield.placeholder {
            textfield.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: color]
            )
            view.backgroundColor = color
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
