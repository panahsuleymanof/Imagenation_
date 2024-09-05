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
        topicName.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        topicName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
