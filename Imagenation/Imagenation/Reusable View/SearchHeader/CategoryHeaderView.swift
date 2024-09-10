//
//  CategoryHeaderView.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 04.09.24.
//

import UIKit
import Kingfisher

class CategoryHeaderView: UICollectionReusableView {

    @IBOutlet private weak var collection: UICollectionView!
    
    private var topics: [Topic] = []
    var callBack: ((Topic) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        collection.dataSource = self
        collection.delegate = self
        collection.register(UINib(nibName: "\(CategoryCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(CategoryCell.self)")
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
    }
    
    func configure(topics: [Topic]) {
        self.topics = topics
        collection.reloadData()
    }
}

extension CategoryHeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoryCell.self)", for: indexPath) as! CategoryCell
        cell.layer.cornerRadius = 8
        let topic = topics[indexPath.item]
        cell.topicName.text = topic.title
        let url = URL(string: topic.cover_photo.urls.regular)
        cell.image.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 120, height: collectionView.frame.height/2 - 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = topics[indexPath.item]
        callBack?(topic)
    }
}
