//
//  ChangePasswordVC.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 09.10.24.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let passwordPlaceholders = ["Current Password","New Password", "Confirm New Password"]
    var passwordTextFields: [UITextField] = []
    
    var userEmail = UserDefaults.standard.string(forKey: "email")

    let viewModel = ChangePasswordVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigation()
    }
    
    private func setNavigation() {
        title = "Change Password"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PasswordCell")
        view.addSubview(tableView)
        setTableViewConstraints()
    }
    
    private func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    @objc func saveTapped() {
        if let email = userEmail,
           let currentPassword = passwordTextFields[0].text,
           let newPassword = passwordTextFields[1].text,
           let confirmPassword = passwordTextFields[2].text {
            if !currentPassword.isEmpty && !newPassword.isEmpty && !confirmPassword.isEmpty {
                if confirmPassword == newPassword {
                    viewModel.changeUserPassword(email: email, currentPassword: currentPassword, newPassword: newPassword)
                    viewModel.success = { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                    viewModel.error = { [weak self] errorMessage in
                        self?.showErrorAlert(message: errorMessage)
                    }
                } else {
                    showErrorAlert(message: "New password and confirm password do not match.")
                }
            } else {
                showErrorAlert(message: "All fields must be filled.")
            }
        }
    }
}

extension ChangePasswordVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        passwordPlaceholders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordCell", for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = passwordPlaceholders[indexPath.row]
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        
        cell.contentView.addSubview(textField)
        
        passwordTextFields.append(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
            textField.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10),
        ])
        
        cell.selectionStyle = .none
        return cell
    }

}
