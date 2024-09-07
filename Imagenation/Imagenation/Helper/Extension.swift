//
//  Extension.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 04.09.24.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension HomeController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }

            // Create an item with a fractional width (full width)
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0) // Adjust height dynamically
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Calculate height dynamically for each cell based on the image aspect ratio
            let group = self.createDynamicGroup(layoutEnvironment: layoutEnvironment)

            // Create section
            let section = NSCollectionLayoutSection(group: group)

            // Create header size with height 40
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            sectionHeader.pinToVisibleBounds = true // Sticky header
            section.boundarySupplementaryItems = [sectionHeader]

            return section
        }
        return layout
    }

    func createDynamicGroup(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutGroup {
        // Create a custom group for dynamic height
        let groupSize: NSCollectionLayoutSize

        // Get the width of the collection view
        let containerWidth = layoutEnvironment.container.effectiveContentSize.width
        
        // Fetch the image aspect ratio for each item dynamically
        let aspectRatioProvider: (Int) -> CGFloat? = { index in
            guard index < self.viewModel.photos.count else { return nil }
            let photo = self.viewModel.photos[index]
            guard let imageWidth = photo.width, let imageHeight = photo.height else { return nil }
            return CGFloat(imageHeight) / CGFloat(imageWidth)
        }

        // Use estimated height for unknown aspect ratios
        let defaultHeight: CGFloat = 300
        
        // For each photo, create a group with a dynamic height based on aspect ratio
        let groupProvider: (Int) -> CGFloat = { index in
            if let aspectRatio = aspectRatioProvider(index) {
                // Calculate dynamic height based on the aspect ratio
                return containerWidth * aspectRatio
            } else {
                // Fallback if the aspect ratio is missing
                return defaultHeight
            }
        }

        // Create group dynamically based on the first item (or adjust logic for other items)
        let groupHeight = groupProvider(0)
        
        groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(groupHeight)
        )

        // Return the group with the dynamic height
        return NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [
                NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                ))
            ]
        )
    }
}
