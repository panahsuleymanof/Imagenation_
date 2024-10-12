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
    
    let manager = FirebaseManager.shared
    
    func changeUserPassword(email: String, currentPassword: String, newPassword: String) {
        manager.reauthenticateUser(email: email, currentPassword: currentPassword) { success in
            if success {
                self.manager.changePassword(newPassword: newPassword)
                self.success?()
            } else {
                self.error?("Password change failed due to failed reauthentication.")
            }
        }
    }
}
