//
//  EditProfileVIewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 02.10.24.
//

import Foundation

class UserInformationVM {
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    var userDetail = [String]()
    
    func getUserInfo(email: String) {
        FirebaseManager.shared.getUserInfo(forUserEmail: email) { [weak self] result in
            switch result {
            case .success(let user):
                self?.userDetail = user
                self?.success?()
            case .failure(let error):
                self?.error?(error.localizedDescription)
            }
        }
    }
}
