//
//  CollectionController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import UIKit

class CollectionController: UIViewController {
    @IBOutlet weak var collection: UICollectionView!
    
    let viewModel = CollectionViewModel()
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchField()
        setCollection()
    }
    
    func setSearchField() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self // Set delegate for UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        //searchController.searchBar.delegate = self // Optional: for handling cancel button
        definesPresentationContext = true
        searchController.searchBar.tintColor = .white
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = UIColor(hex: "29292b")
            searchTextField.attributedPlaceholder = NSAttributedString(
                string: "Search collections",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            if let glassIconView = searchTextField.leftView as? UIImageView {
                glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                glassIconView.tintColor = UIColor.lightGray
            }
        }
    }

    func setCollection() {
        collection.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collection.backgroundColor = .clear
    }
}

extension CollectionController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 200)
    }
}

extension CollectionController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
}
