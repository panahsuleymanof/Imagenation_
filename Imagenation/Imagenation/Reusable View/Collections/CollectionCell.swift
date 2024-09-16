//
//  CollectionCell.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import UIKit
import Kingfisher

import UIKit
import Kingfisher

class CollectionCell: UICollectionViewCell {

    @IBOutlet private weak var collection: UICollectionView!
    @IBOutlet private weak var collectionName: UILabel!
    @IBOutlet private weak var collectionDetail: UILabel!
    
    var photos = [PreviewPhoto]()
    
    private var collections: [Collection] = []
    
    var name: String? {
        didSet {
            setLabels()
        }
    }
    
    var photoCount: Int? {
        didSet {
            setLabels()
        }
    }
    
    var author: String? {
        didSet {
            setLabels()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }

    func setCollectionView() {
        collection.dataSource = self
        collection.delegate = self
        collection.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        collection.showsHorizontalScrollIndicator = false
    }
    
    func setLabels() {
        if let name = name,
           let count = photoCount,
           let authorName = author {
            collectionName.text = name
            collectionDetail.text = "\(count) photos • Curated by \(authorName)"
        }
    }
    
    func configure(with collection: Collection) {
        self.photos.removeAll()
        self.photos.append(contentsOf: collection.previewPhotos ?? [])
        self.collection.reloadData()
    }
}

extension CollectionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let photo = photos[indexPath.item]
        let url = URL(string: photo.urls?.regular ?? "")
        cell.image.kf.setImage(with: url)
        return cell
    }
}
