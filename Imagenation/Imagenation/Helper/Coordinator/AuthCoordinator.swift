//
//  AuthCoordinator.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 24.01.25.
//

import UIKit

protocol AuthCoordinatorProtocol {
    func start()
    func navigateToRegister()
    func navigateToHome()
}

class AuthCoordinator: AuthCoordinatorProtocol {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(LoginVC.self)") as! LoginVC
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: false)
    }

    func navigateToRegister() {
        let registerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(RegisterVC.self)") as! RegisterVC
        registerVC.coordinator = self
        registerVC.logInCallBack = { [weak self] email, password in
            self?.handleLoginDetails(email: email, password: password)
        }
        navigationController.show(registerVC, sender: true)
    }

    func navigateToHome() {
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate: SceneDelegate = scene?.delegate as? SceneDelegate {
            sceneDelegate.setHomeAsRoot()
        }
    }

    private func handleLoginDetails(email: String, password: String) {
        if let loginVC = navigationController.viewControllers.first(where: { $0 is LoginVC }) as? LoginVC {
            loginVC.setEmailAndPassword(email: email, password: password)
        }
        navigationController.popViewController(animated: true)
    }
}
