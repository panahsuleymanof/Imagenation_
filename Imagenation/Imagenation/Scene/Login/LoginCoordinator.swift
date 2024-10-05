//
//  LoginCoordinator.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 09.08.24.
//

import Foundation
import UIKit

class LoginCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterController") as! RegisterVC
        navigationController.show(controller, sender: nil)
    }
}
