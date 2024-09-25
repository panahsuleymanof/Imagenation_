//
//  CollectionController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 07.09.24.
//

import UIKit

class CollectionController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet private weak var collection: UICollectionView!
    
    let viewModel = CollectionViewModel()
    let clearButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollection()
        configureViewModel()
        configureNavigationBar()
        setTextField()
        setupClearButton()
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
    
    func setTextField() {
        textField.backgroundColor = .clear
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search collections",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "a2a2a9")]
        )
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func setCollection() {
        collection.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collection.backgroundColor = .clear
    }
    
    func setupClearButton() {
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        
        textField.rightView = clearButton
        textField.rightViewMode = .always
        
        clearButton.isHidden = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            clearButton.isHidden = true
            viewModel.resetSearch()
            collection.reloadData()
        } else {
            clearButton.isHidden = false
        }
    }
    
    @objc func clearTextField() {
        if !viewModel.searchedCollections.isEmpty {
            collection.setContentOffset(CGPoint(x: 0, y: -collection.contentInset.top), animated: true)
            viewModel.resetSearch()
            collection.reloadData()
        }
        textField.text = ""
        clearButton.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if let text = textField.text, !text.isEmpty {
            collection.setContentOffset(CGPoint(x: 0, y: -collection.contentInset.top), animated: true)
            viewModel.resetSearch()
            viewModel.isSearching = true
            viewModel.getSearchedCollections(query: text)
        } else {
            viewModel.resetSearch()
            collection.reloadData()
        }
    }
}

extension CollectionController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.searchedCollections.isEmpty ? viewModel.collections.count : viewModel.searchedCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.layer.cornerRadius = 8
        let collection: Collection
        if viewModel.searchedCollections.isEmpty {
            collection = viewModel.collections[indexPath.item]
        } else {
            collection = viewModel.searchedCollections[indexPath.item]
        }
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
        if viewModel.isSearching {
            if let query = textField.text, !query.isEmpty {
                viewModel.pagination(index: indexPath.item, query: query)
            }
        } else {
            viewModel.pagination(index: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "\(CollectionPhotosController.self)") as! CollectionPhotosController
        let collection: Collection
        if viewModel.searchedCollections.isEmpty {
            collection = viewModel.collections[indexPath.item]
        } else {
            collection = viewModel.searchedCollections[indexPath.item]
        }
        vc.collectionId = collection.id
        vc.title = collection.title
        vc.setupAuthorLabel(name: collection.user?.name ?? "")
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.show(vc, sender: nil)
    }
}
