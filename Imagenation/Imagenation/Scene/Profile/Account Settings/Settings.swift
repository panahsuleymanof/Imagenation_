//
//  AccountSettings.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 22.09.24.
//


import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let sections = [
        ["User Info", "Change Password", "Account"],
        ["Privacy & Policy", "Terms of Service"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        customizeNavigationBarAppearance()
    }
    
    func setupNavigationBar() {
        title = "Settings"
        
        navigationController?.navigationBar.tintColor = .lightGray
        
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem = dismissButton
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    func customizeNavigationBarAppearance() {
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemGroupedBackground
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.label
            ]
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.backgroundColor = UIColor.systemGroupedBackground
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        cell.backgroundColor = UIColor.secondarySystemGroupedBackground
        cell.textLabel?.textColor = UIColor.label
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    // MARK: - TableView Section Headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Account Settings"
        } else {
            return "Legal Information"
        }
    }
    
    // MARK: - TableView Section Footers
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "Review the legal documents."
        }
        return nil
    }
    
    // MARK: - TableView Delegate for Row Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = sections[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let vc = UserInformationVC()
                navigationController?.show(vc, sender: nil)
            } else if indexPath.row == 1 {
                let vc = ChangePasswordVC()
                navigationController?.show(vc, sender: nil)
            } else if indexPath.row == 2 {
                let vc = AccountVC()
                navigationController?.show(vc, sender: nil)
            }
        } else {
            print("Selected \(selectedItem)")
        }
        print("Selected \(sections[indexPath.section][indexPath.row])")
    }
}

