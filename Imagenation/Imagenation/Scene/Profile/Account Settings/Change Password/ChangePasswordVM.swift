//
//  ChnagePasswordVM.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 09.10.24.
//

import Foundation

class ChangePasswordVM {
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    

    func changeUserPassword(email: String, currentPassword: String, newPassword: String) {
        FirebaseManager.shared.reauthenticateUser(email: email, currentPassword: currentPassword) { [weak self] success in
            if success {
                FirebaseManager.shared.changePassword(newPassword: newPassword)
                self?.success?()
            } else {
                self?.error?("Password change failed due to failed reauthentication.")
            }
        }
    }
    
}
