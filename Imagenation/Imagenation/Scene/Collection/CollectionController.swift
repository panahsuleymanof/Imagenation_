//
//  CollectionController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import UIKit

class CollectionController: UIViewController {
    @IBOutlet private weak var collection: UICollectionView!
    
    let viewModel = CollectionViewModel()
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchField()
        setCollection()
        configureViewModel()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        guard let navigationController = navigationController else { return }

        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        // Make the navigation bar transparent
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.backgroundColor = .clear
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
    
    func configureViewModel() {
        viewModel.getCollections()
        viewModel.error = { errorMessage in
            print(errorMessage)
        }
        viewModel.success = {
            self.collection.reloadData()
        }
    }
}

extension CollectionController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.layer.cornerRadius = 8
        let collection = viewModel.collections[indexPath.item]
        cell.author = collection.user?.name
        cell.name = collection.title
        cell.photoCount = collection.totalPhotos
        cell.configure(with: collection)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collection = viewModel.collections[indexPath.item]
        let vc = storyboard?.instantiateViewController(identifier: "\(CollectionPhotosController.self)") as! CollectionPhotosController
        vc.collectionId = collection.id
        vc.title = collection.title
        vc.setupAuthorLabel(name: collection.user?.name ?? "")
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.show(vc, sender: nil)
    }
}

extension CollectionController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
}
