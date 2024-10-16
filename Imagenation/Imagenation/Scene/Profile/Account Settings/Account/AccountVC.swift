//
//  AccountVC.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 12.10.24.
//

import UIKit

class AccountVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let passwordTextField = UITextField()
    private let errorLabel: UILabel = {
        let il = UILabel()
        il.backgroundColor = .secondarySystemGroupedBackground
        return il
    }()
    
    var userEmail = UserDefaults.standard.string(forKey: "email")

    let viewModel = AccountVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Close Account"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func logout() {
        let alertController = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            UserDefaults.standard.set("", forKey: "email")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.set("", forKey: "fullName")
            let scene = UIApplication.shared.connectedScenes.first
            if let sceneDelegate: SceneDelegate = scene?.delegate as? SceneDelegate {
                sceneDelegate.setLoginAsRoot()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - TableView DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "WARNING"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = """
            Closing your account is irreversible. It deletes all of your photos, collections, and stats.
            
            Deleting your account removes all of your photos from Unsplash. However, the Unsplash License is irrevocable, so copies of the photo that were downloaded before deletion may still be used.
            """
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
        case 1:
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
            passwordTextField.borderStyle = .none
            passwordTextField.backgroundColor = .secondarySystemGroupedBackground
            passwordTextField.textColor = .white
            passwordTextField.layer.cornerRadius = 8
            passwordTextField.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(passwordTextField)
            
            NSLayoutConstraint.activate([
                passwordTextField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                passwordTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                passwordTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                passwordTextField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                passwordTextField.heightAnchor.constraint(equalToConstant: 28)
            ])
            cell.selectionStyle = .none
            cell.backgroundColor = .secondarySystemGroupedBackground
            
        case 2:
            let closeButton = UIButton(type: .system)
            closeButton.setTitle("Close account", for: .normal)
            closeButton.setTitleColor(.red, for: .normal)
            closeButton.backgroundColor = .secondarySystemGroupedBackground
            closeButton.layer.cornerRadius = 8
            closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.addTarget(self, action: #selector(closeAccountTapped), for: .touchUpInside)
            cell.contentView.addSubview(closeButton)
            
            NSLayoutConstraint.activate([
                closeButton.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
                closeButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
                closeButton.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                closeButton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                closeButton.heightAnchor.constraint(equalToConstant: 28)
            ])
            cell.selectionStyle = .none
            cell.backgroundColor = .secondarySystemGroupedBackground
            
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - Button Action
    
    @objc func closeAccountTapped() {
        if let password = passwordTextField.text,
           let email = userEmail, !password.isEmpty {
            viewModel.deleteUser(email: email, password: password)
            logout()
        } else {
            showErrorAlert(message: "Password is empty")
        }
    }
}
