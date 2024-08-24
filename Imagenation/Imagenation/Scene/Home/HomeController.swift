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
    var topics: [Topic] = []
    var photos: [Photo] = []
    var selectedTopic: Topic?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTopics()
    }
    
    func configureUI() {
        self.navigationItem.title = "ImageNation"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor = .clear
        collection.register(UINib(nibName: "\(TopicHeaderView.self)", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(TopicHeaderView.self)")
        collection.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
    
    func fetchTopics() {
        FetchTopics.shared.fetchTopics { [weak self] topics in
            guard let self = self else { return }
            if let topics = topics {
                self.topics = topics
                self.collection.reloadData()
            }
        }
    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.backgroundColor = .gray
        let photo = photos[indexPath.item]
        if let url = URL(string: photo.urls.regular) {
            cell.image.kf.setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(TopicHeaderView.self)", for: indexPath) as! TopicHeaderView
        header.configure(topics: topics) { [weak self] selectedTopic in
            guard let self = self else { return }
            FetchTopics.shared.fetchPhotos(forTopic: selectedTopic.id) { photos in
                if let photos = photos {
                    self.photos = photos
                    self.collection.reloadData()
                }
            }
        }        
        return header
    }
}
