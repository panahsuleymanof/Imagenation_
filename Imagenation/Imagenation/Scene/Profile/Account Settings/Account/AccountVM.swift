//
//  AccountVM.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 12.10.24.
//

import Foundation

class AccountVM {
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    

    func deleteUser(email: String, password: String) {
        FirebaseManager.shared.reauthenticateUser(email: email, currentPassword: password) { [weak self] success in
            if success {
                FirebaseManager.shared.deleteUser(forUserEmail: email)
                self?.success?()
            } else {
                self?.error?("Password change failed due to failed reauthentication.")
            }
        }
    }
}
