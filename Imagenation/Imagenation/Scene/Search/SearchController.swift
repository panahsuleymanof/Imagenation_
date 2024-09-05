//
//  SearchController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 04.09.24.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    let viewModel = SearchViewModel()
    
    let searchController = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchField()
        configureUI()
        collection.backgroundColor = .clear
        configureViewModel()
    }
    
    func setSearchField() {
        navigationItem.searchController = searchController
        searchController.searchBar.tintColor = .white
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = UIColor(hex: "29292b")
            searchTextField.attributedPlaceholder = NSAttributedString(
                string: "Search photos, collections, users",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            if let glassIconView = searchTextField.leftView as? UIImageView {
                glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                glassIconView.tintColor = UIColor.lightGray
            }
        }
    }
    
    func configureUI() {
        collection.register(UINib(nibName: "CategoryHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CategoryHeaderView")
        collection.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
    
    func configureViewModel() {
        viewModel.getTopics()
        viewModel.error = { errorMessage in
            print("Error: \(errorMessage)")
        }
        viewModel.success = {
            self.collection.reloadData()
        }
    }
}

extension SearchController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        200
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(CategoryHeaderView.self)", for: indexPath) as! CategoryHeaderView
        header.configure(topics: viewModel.topics)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width/2 - 2, height: 200)
    }
}
