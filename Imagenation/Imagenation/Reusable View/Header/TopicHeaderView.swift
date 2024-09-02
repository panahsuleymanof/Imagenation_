//
//  TopicHeaderView.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 23.08.24.
//

import UIKit

class TopicHeaderView: UICollectionReusableView {
    @IBOutlet weak var collection: UICollectionView!
    
    private var selectedIndex: IndexPath?
    private var topics: [Topic] = []

    var onTopicSelected: ((Topic) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        collection.dataSource = self
        collection.delegate = self
        collection.register(UINib(nibName: "\(TopicCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(TopicCell.self)")
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
    }
    
    func configure(topics: [Topic], onTopicSelected: @escaping (Topic) -> Void) {
        self.topics = topics
        self.onTopicSelected = onTopicSelected
        collection.reloadData()
    }
}

extension TopicHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TopicCell.self)", for: indexPath) as! TopicCell
        let topic = topics[indexPath.item]
        cell.topicName.text = topic.title
        cell.view.backgroundColor = .gray
        
        if indexPath == selectedIndex {
            cell.view.backgroundColor = .white
        }
        return cell
    }
    
}

extension TopicHeaderView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let selectedTopic = topics[indexPath.item]
        onTopicSelected?(selectedTopic)
        if let previousIndex = selectedIndex, 
            let previousCell = collectionView.cellForItem(at: previousIndex) as? TopicCell {
            previousCell.view.backgroundColor = .gray
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TopicCell {
            cell.view.backgroundColor = .white
        }
        
        selectedIndex = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 140, height: 40)
    }
}
