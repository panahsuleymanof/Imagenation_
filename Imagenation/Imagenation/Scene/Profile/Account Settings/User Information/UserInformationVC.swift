//
//  EditProfile.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 01.10.24.
//

import UIKit

class UserInformationVC: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    let viewModel = UserInformationVM()
    let email = UserDefaults.standard.string(forKey: "email")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Info"
        configureViewModel()
        setTableView()
    }
    
    private func configureViewModel() {
        if let email = email {
            viewModel.getUserInfo(email: email)
        }
        viewModel.success = {
            self.tableView.reloadData()
        }
        viewModel.error = { errorMessage in
            print(errorMessage)
        }
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register( UITableViewCell.self, forCellReuseIdentifier: "cell")
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
}

extension UserInformationVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.userDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = viewModel.userDetail[indexPath.item]
        return cell
    }
  
}
