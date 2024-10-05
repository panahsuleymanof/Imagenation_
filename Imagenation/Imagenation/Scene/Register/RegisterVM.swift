//
//  RegisterViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 14.08.24.
//

import Foundation

class RegisterVM {
    var registerSuccess: (() -> Void)?
    var registerFailed: ((String) -> Void)?
    
    func registerUser(firstName: String, lastName: String, username: String, email: String, password: String) {
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "email": email
        ]
        
        FirebaseManager.shared.createUser(email: email, password: password, userData: userData) { [weak self] result in
            switch result {
            case .success:
                self?.registerSuccess?()
            case .failure(let error):
                self?.registerFailed?(error.localizedDescription)
            }
        }
    }
}
