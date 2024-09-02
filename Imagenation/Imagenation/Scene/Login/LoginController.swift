//
//  LoginController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 31.07.24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class UserDetails {
    static let shared = UserDetails()
    
    var name = ""
    var surname = ""
    var username = ""
    var email = ""
}

class LoginController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailFieldView: UIView!
    @IBOutlet weak var pswdField: UITextField!
    @IBOutlet weak var pswdFieldView: UIView!
    
    let viewModel = LoginViewModel()
    let database = Firestore.firestore()
    var users = [UserInfo]()
    
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
        func getUsers() -> [UserInfo] {
            var allUsers = [UserInfo]()
            database.collection("Users").getDocuments { snapshot, error in
                if let error {
                    print(error.localizedDescription)
                } else if let snapshot {
                    for document in snapshot.documents {
                        let dict = document.data()
                        if let jsonData = try? JSONSerialization.data(withJSONObject: dict) {
                            do {
                                let user = try JSONDecoder().decode(UserInfo.self, from: jsonData)
                                allUsers.append(user)
                            } catch {
                                print("error: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            return allUsers
        }
        if let email = emailField.text,
           let password = pswdField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult,error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let users = getUsers()
                    if let userIndex = users.firstIndex(where: {$0.email == email}) {
                        UserDetails.shared.email = email
                        UserDetails.shared.name = users[userIndex].firstName
                        UserDetails.shared.surname = users[userIndex].lastName
                        UserDetails.shared.username = users[userIndex].username
                    }
//                    let vc = self.storyboard?.instantiateViewController(identifier: "\(HomeController.self)") as! HomeController
//                    self.navigationController?.show(vc, sender: nil)
                }
            }
        }
    }
    
    @IBAction func joinTapped(_ sender: Any) {
//        let coordinator = LoginCoordinator(navigationController: self.navigationController ?? UINavigationController())
//        coordinator.start()
        let vc = storyboard?.instantiateViewController(identifier: "\(RegisterController.self)") as! RegisterController
        vc.logInCallBack = { [weak self] email, password in
            self?.emailField.text = email
            self?.pswdField.text = password
        }
        navigationController?.show(vc, sender: nil)
    }
}

