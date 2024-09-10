//
//  LoginViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 09.08.24.
//

import Foundation

class LoginViewModel {
    var loginSuccess: (() -> Void)?
    var loginFailed: ((String) -> Void)?
    
    func loginUser(email: String, password: String) {
        FirebaseManager.shared.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.fetchUsers(email: email)
            case .failure(let error):
                self?.loginFailed?(error.localizedDescription)
            }
        }
    }
    
    private func fetchUsers(email: String) {
        FirebaseManager.shared.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                if let user = users.first(where: {$0.email == email}) {
                    UserDefaults.standard.set("\(user.firstName) \(user.lastName)", forKey: "fullName")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self?.loginSuccess?()
                } else {
                    self?.loginFailed?("User not found.")
                }
            case .failure(let error):
                self?.loginFailed?(error.localizedDescription)
            }
        }
    }
}
