//
//  CategoryCell.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 04.09.24.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var topicName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        topicName.lineBreakMode = .byWordWrapping
    }
}
