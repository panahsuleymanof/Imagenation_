//
//  HomeController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 14.08.24.
//

import UIKit
import Alamofire
import Kingfisher

class HomeController: UIViewController {
    @IBOutlet private weak var collection: UICollectionView!
    
    let viewModel = HomeViewModel()
    var selectedTopic: Topic?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        collection.backgroundColor = .clear
        configureNavigationBar()
        configureUI()
        configureViewModel()
    }
        
    func configureUI() {
        collection.register(UINib(nibName: "\(TopicHeaderView.self)", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(TopicHeaderView.self)")
        collection.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        collection.collectionViewLayout = createLayout()
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

        // Set title text attributes (optional)
        navigationItem.title = "ImageNation"
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func configureViewModel() {
        viewModel.getTopics()
        viewModel.error = { errorMessage in
            print("Error: \(errorMessage)")
        }
        viewModel.success = {
            if let firstTopic = self.viewModel.topics.first {
                self.selectedTopic = firstTopic
            }
            self.collection.reloadData()
        }
    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.backgroundColor = .gray
        let photo = viewModel.photos[indexPath.item]
        if let url = URL(string: photo.urls.regular) {
            cell.image.kf.setImage(with: url)
            cell.userName.text = photo.user.name
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(TopicHeaderView.self)", for: indexPath) as! TopicHeaderView
        header.configure(topics: viewModel.topics) { [weak self] topic in
            guard let self = self else { return }
            collectionView.selectItem(at: IndexPath(row: 0, section: 0),
                                      animated: true,
                                      scrollPosition: .centeredVertically)
            viewModel.page = 1
            selectedTopic = topic
            viewModel.getPhotos(topicID: topic.id, isFromTopic: true)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("Displaying cell at index \(indexPath.item)")
        viewModel.pagination(index: indexPath.item, id: selectedTopic?.id ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "\(PhotoDetailController.self)") as! PhotoDetailController
        let photo = viewModel.photos[indexPath.item]
        vc.photoURL = photo.urls.raw
        vc.username = photo.user.name
        vc.photoId = photo.id
        vc.altDescription = photo.altDescription
        vc.hidesBottomBarWhenPushed = true
        navigationController?.show(vc, sender: nil)
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = viewModel.photos[indexPath.item]
        
        guard let imageWidth = photo.width, let imageHeight = photo.height else {
            return CGSize(width: collectionView.frame.width, height: 300)
        }
        
        let aspectRatio = CGFloat(imageHeight) / CGFloat(imageWidth)
        let cellWidth = collectionView.frame.width
        let cellHeight = cellWidth * aspectRatio
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
