//
//  TopicCell.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 23.08.24.
//

import UIKit

class TopicCell: UICollectionViewCell {

    @IBOutlet weak var topicName: UILabel!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        topicName.backgroundColor = .clear
        topicName.adjustsFontSizeToFitWidth = true // Enable dynamic font resizing
        topicName.minimumScaleFactor = 0.8 // Allow the font to scale down to 80% of its original size
        topicName.lineBreakMode = .byTruncatingTail // To handle longer text
    }
}
