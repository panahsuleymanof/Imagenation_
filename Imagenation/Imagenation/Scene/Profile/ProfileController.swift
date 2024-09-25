//
//  ProfileController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 04.09.24.
//

import UIKit

class ProfileController: UIViewController {
    @IBOutlet private weak var accountView: UIView!
    @IBOutlet private weak var collection: UICollectionView!
    @IBOutlet private weak var fullName: UILabel!
    
    let viewModel = ProfileViewModel()

    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
        configureNavigationBar()
        view.addSubview(emptyImageView)
        setImageConstraints()
        fullName.text = UserDefaults.standard.string(forKey: "fullName")
        setupCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViewModel()
    }
    
    func configureNavigationBar() {
        guard let navigationController = navigationController else { return }

        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        // Make the navigation bar transparent
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.backgroundColor = .clear
    }

    func setBarButtonItem() {
        let accountSettingsAction = UIAction(title: "Account Settings", image: UIImage(systemName: "gearshape")) { _ in
            self.openAccountSettings()
        }
        let logoutAction = UIAction(title: "Log Out", image: UIImage(systemName: "arrow.right.square")) { _ in
            self.logout()
        }
        let menu = UIMenu(title: "", children: [accountSettingsAction, logoutAction])
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), menu: menu)
        self.navigationItem.rightBarButtonItem = menuButton
    }
    
    func setImageConstraints() {
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyImageView.topAnchor.constraint(equalTo: accountView.bottomAnchor, constant: 48),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 360),
            emptyImageView.heightAnchor.constraint(equalToConstant: 360)
        ])
    }
    
    func configureViewModel() {
        if let email = UserDefaults.standard.string(forKey: "email") {
            viewModel.getIds(email: email)
            viewModel.error = { error in
                self.updateUI()
                print(error)
            }
            viewModel.success = {
                self.updateUI()
                self.collection.reloadData()
            }
        }
    }
    
    func setupCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        collection.collectionViewLayout = layout
        collection.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        collection.backgroundColor = .clear
    }
    
    func updateUI() {
        if viewModel.photos.isEmpty {
            collection.isHidden = true
            emptyImageView.isHidden = false
        } else {
            collection.isHidden = false
            emptyImageView.isHidden = true
        }
    }
    
    func openAccountSettings() {
        let vc = SettingsViewController()
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true)
    }
    
    func logout() {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            UserDefaults.standard.set("", forKey: "email")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.set("", forKey: "fullName")
            let scene = UIApplication.shared.connectedScenes.first
            if let sceneDelegate: SceneDelegate = scene?.delegate as? SceneDelegate {
                sceneDelegate.setLoginAsRoot()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ProfileController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let photo = viewModel.photos[indexPath.item]
        if let url = URL(string: photo.urls.regular) {
            cell.image.kf.setImage(with: url)
            cell.userName.text = photo.user.name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.photos[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "\(PhotoDetailController.self)") as! PhotoDetailController
        vc.photoURL = photo.urls.regular
        vc.username = photo.user.name
        vc.photoId = photo.id
        vc.altDescription = photo.altDescription
        vc.hidesBottomBarWhenPushed = true
        navigationController?.show(vc, sender: nil)
    }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        return CGSize(width: width, height: 300)
    }
}

extension ProfileController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        true
    }
}
