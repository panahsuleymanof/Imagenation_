//
//  AccountSettings.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 22.09.24.
//

import UIKit

class AccountSettings: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let accountSetings = ["User Info", "Change Password", "Delete Account", "Privacy & Policy"]
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6

        setupNavigationBar()
        setupTableView()
    }
    
    
    func setupNavigationBar() {
        title = "Settings"
        
        // Add dismiss button on the left
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.systemGray6
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accountSetings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = accountSetings[indexPath.row]
        cell.textLabel?.textColor = .label
        cell.backgroundColor = UIColor.systemGray6
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Implement navigation to different settings here based on selection
    }
}
