//
//  LoginController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 31.07.24.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var emailFieldView: UIView!
    @IBOutlet private weak var pswdField: UITextField!
    @IBOutlet private weak var pswdFieldView: UIView!
    
    let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setChangableColor(textfield: emailField, view: emailFieldView, color: .lightGray)
        setChangableColor(textfield: pswdField, view: pswdFieldView, color: .lightGray)
    }
    
    private func configureUI() {
        title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        emailField.delegate = self
        pswdField.delegate = self
    }
    
    private func setupBindings() {
        viewModel.loginSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToHome()
            }
        }
        
        viewModel.loginFailed = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showError(message: errorMessage)
            }
        }
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        guard let email = emailField.text, let password = pswdField.text else {
            return
        }
        viewModel.loginUser(email: email, password: password)
    }
    
    @IBAction func joinTapped(_ sender: Any) {
        let registerVC = storyboard?.instantiateViewController(withIdentifier: "\(RegisterController.self)") as! RegisterController
        registerVC.logInCallBack = { [weak self] email, password in
            self?.emailField.text = email
            self?.pswdField.text = password
        }
        navigationController?.show(registerVC, sender: nil)
    }
    
    // MARK: - TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateColor(textField: textField, color: .white)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateColor(textField: textField, color: .lightGray)
    }
    
    // MARK: - Helper Methods
    private func updateColor(textField: UITextField, color: UIColor) {
        if textField == emailField {
            setChangableColor(textfield: emailField, view: emailFieldView, color: color)
        } else if textField == pswdField {
            setChangableColor(textfield: pswdField, view: pswdFieldView, color: color)
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
    
    private func navigateToHome() {
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate: SceneDelegate = scene?.delegate as? SceneDelegate {
            sceneDelegate.setHomeAsRoot()
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

