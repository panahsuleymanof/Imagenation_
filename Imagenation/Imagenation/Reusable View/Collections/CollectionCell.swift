//
//  CollectionCell.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import UIKit

class CollectionCell: UICollectionViewCell {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var collectionDetail: UILabel!
    
    var name: String?
    var photoCount: String?
    var author: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }

    func setCollectionView() {
        collection.dataSource = self
        collection.delegate = self
        collection.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
    
    func setLabels() {
        if let name = name,
           let count = photoCount,
           let authorName = author {
            collectionName.text = name
            collectionDetail.text = "\(count) photos • Curated by \(authorName)"
        }
    }
}

extension CollectionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        return cell
    }
    
}
