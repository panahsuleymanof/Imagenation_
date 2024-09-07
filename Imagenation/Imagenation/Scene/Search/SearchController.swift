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
                string: "Search photos",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            if let glassIconView = searchTextField.leftView as? UIImageView {
                glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                glassIconView.tintColor = UIColor.lightGray
            }
        }
    }
    
    func configureUI() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
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
        header.callBack = { topic in
            let vc = self.storyboard?.instantiateViewController(identifier: "\(TopicController.self)") as! TopicController
            vc.topicId = topic.id
            vc.title = topic.title
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.show(vc, sender: nil)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        return CGSize(width: width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "\(PhotoDetailController.self)") as! PhotoDetailController
        let photo = viewModel.photos[indexPath.item]
        vc.photoURL = photo.urls.raw
        vc.title = photo.user.name
        vc.hidesBottomBarWhenPushed = true
        navigationController?.show(vc, sender: nil)
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
