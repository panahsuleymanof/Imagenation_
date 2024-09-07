//
//  SearchController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 04.09.24.
//

import UIKit
import Kingfisher

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
        searchController.searchResultsUpdater = self // Set delegate for UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        //searchController.searchBar.delegate = self // Optional: for handling cancel button
        definesPresentationContext = true
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
        viewModel.getPhotos()
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
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let photo = viewModel.photos[indexPath.item]
        if let url = URL(string: photo.urls.regular) {
            cell.image.kf.setImage(with: url)
            cell.userName.text = photo.user.name
        }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.item)
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Get the search bar text
        guard let searchText = searchController.searchBar.text else { return }
        let lowercasedQuery = searchText.lowercased()
        
        if !lowercasedQuery.isEmpty {
            viewModel.searchPhotos(query: lowercasedQuery)
        } else {
            viewModel.resetSearch()
        }
    }
}
