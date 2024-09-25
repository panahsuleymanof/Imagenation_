//
//  CollectionPhotosController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 08.09.24.
//

import UIKit

class CollectionPhotosController: UIViewController {
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet private weak var collection: UICollectionView!
    
    let viewModel = CollectionPhotoViewModel()
    var collectionId: String?
    private var author: String?
    
    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emptyImageView)
        setImageConstraints()
        setupCollection()
        configureViewModel()
        configureNavigationBar()
        
        if let name = author {
            authorName.text = "Curated by \(name)"
        }
    }

    func setImageConstraints() {
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 400),
            emptyImageView.heightAnchor.constraint(equalToConstant: 400)
        ])
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
    
    func setupAuthorLabel(name: String) {
        self.author = name // Store the name in the variable
    }
    
    func configureViewModel() {
        if let id = collectionId {
            viewModel.getPhotos(collectionId: id)
        }
        viewModel.error = { errorMessage in
            print("Error: \(errorMessage)")
            self.updateUI()
        }
        viewModel.success = {
            self.updateUI()
            self.collection.reloadData()
        }
    }
}

extension CollectionPhotosController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "\(PhotoDetailController.self)") as! PhotoDetailController
        vc.photoURL = photo.urls.regular
        vc.username = photo.user.name
        vc.photoId = photo.id
        vc.altDescription = photo.altDescription
        vc.hidesBottomBarWhenPushed = true
        navigationController?.show(vc, sender: nil)
    }
}

extension CollectionPhotosController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        return CGSize(width: width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.item, id: collectionId ?? "")
    }
}
