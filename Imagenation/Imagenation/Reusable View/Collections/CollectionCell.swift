//
//  CollectionCell.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import UIKit
import Kingfisher

class CollectionCell: UICollectionViewCell {

    @IBOutlet private weak var collection: UICollectionView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var collectionDetail: UILabel!
    
    var photos = [PreviewPhoto]()
    var name: String?
    var photoCount: Int?
    var author: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
//        setLabels()
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
        self.photos.removeAll() // Clear the photos array
        self.photos.append(contentsOf: collection.preview_photos ?? [])
        self.collection.reloadData() // Reload the collection view after updating the photos
    }
}

extension CollectionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let photo = photos[indexPath.item]
        let url = URL(string: photo.urls?.regular ?? "")
        cell.image.kf.cancelDownloadTask() // Cancel any ongoing image downloads for reused cells
        cell.image.kf.setImage(with: url) // Load the new image
        return cell
    }
}
