//
//  TopicController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import UIKit
import Kingfisher

class TopicVC: UIViewController {

    @IBOutlet private weak var collection: UICollectionView!
    
    var viewModel = TopicVM()
    var topicId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        configureViewModel()
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
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
    
    func configureViewModel() {
        if let id = topicId {
            viewModel.getPhotos(topicID: id)
        }
        viewModel.error = { errorMessage in
            print("Error: \(errorMessage)")
        }
        viewModel.success = {
            self.collection.reloadData()
        }
    }
}

extension TopicVC: UICollectionViewDataSource, UICollectionViewDelegate {
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "\(PhotoDetailVC.self)") as! PhotoDetailVC
        vc.photoURL = photo.urls.regular
        vc.username = photo.user.name
        vc.photoId = photo.id
        vc.altDescription = photo.altDescription
        vc.hidesBottomBarWhenPushed = true
        navigationController?.show(vc, sender: nil)
    }
}

extension TopicVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        return CGSize(width: width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.item, id: topicId ?? "")
    }
}
