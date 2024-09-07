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
    @IBOutlet weak var collection: UICollectionView!
    
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
            self.collection.reloadData()
        }
    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 300)
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
//            collectionView.setContentOffset(.zero, animated: true)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.item, id: selectedTopic?.id ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Safely instantiate the PhotoDetailController
        guard let vc = storyboard?.instantiateViewController(identifier: "\(PhotoDetailController.self)") as? PhotoDetailController else {
            print("Error: Could not instantiate PhotoDetailController")
            return
        }
        
        // Safely unwrap the photo URL
        let photo = viewModel.photos[indexPath.item]
        guard let url = URL(string: photo.urls.raw) else {
            print("Error: Invalid photo URL")
            return
        }
        
        // Ensure photoImage is not nil
        if vc.image != nil {
            vc.image.kf.setImage(with: url)
        } else {
            print("Error: photoImage is nil")
        }
        
        vc.title = photo.user.name
        navigationController?.show(vc, sender: nil)
    }
}
