//
//  HomeController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 14.08.24.
//

import UIKit
import Alamofire
import Kingfisher

class HomeVC: UIViewController {
    @IBOutlet private weak var collection: UICollectionView!
    
    let viewModel = HomeVM()
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
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        collection.collectionViewLayout = layout
        
        collection.register(UINib(nibName: "\(TopicHeaderView.self)", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(TopicHeaderView.self)")
        collection.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
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

        navigationItem.title = "ImageNation"
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func configureViewModel() {
        viewModel.getTopics()
        viewModel.error = { errorMessage in
            print("Error: \(errorMessage)")
        }
        viewModel.success = {
            if self.viewModel.isTopicsFetched {
                if let firstTopic = self.viewModel.topics.first {
                    self.selectedTopic = firstTopic
                    self.viewModel.isTopicsFetched = false
                }
            }
            self.collection.reloadData()
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
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
            collection.setContentOffset(CGPoint(x: 0, y: -collection.contentInset.top), animated: true)
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
        let vc = storyboard?.instantiateViewController(identifier: "\(PhotoDetailVC.self)") as! PhotoDetailVC
        let photo = viewModel.photos[indexPath.item]
        vc.photoURL = photo.urls.regular
        vc.username = photo.user.name
        vc.photoId = photo.id
        vc.altDescription = photo.altDescription
        vc.hidesBottomBarWhenPushed = true
        navigationController?.show(vc, sender: nil)
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: 40)
    }
}
