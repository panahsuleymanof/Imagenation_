//
//  SearchController.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 04.09.24.
//

import UIKit
import Kingfisher

// MARK: - Properties
class SearchVC: UIViewController, UITextFieldDelegate {
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var collection: UICollectionView!
    
    let viewModel = SearchVM()
    let clearButton = UIButton(type: .custom)

// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViewModel()
        setupToolbar()
        setupClearButton()
        configureCollection()
        configureTextField()
    }
}

// MARK: - UI Configuration
extension SearchVC {
    func configureNavigationBar() {
        guard let navigationController = navigationController else { return }
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.backgroundColor = .clear
    }

    func configureCollection() {
        collection.backgroundColor = .clear

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        collection.register(UINib(nibName: "CategoryHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CategoryHeaderView")
        collection.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
    
    func configureTextField() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.backgroundColor = .clear
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search photos",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "a2a2a9")]
        )
    }
    
    func setupClearButton() {
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        
        textField.rightView = clearButton
        textField.rightViewMode = .always
        clearButton.isHidden = true
    }

    func setupToolbar() {
        let bar = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        textField.inputAccessoryView = bar
    }
}

// MARK: - ViewModel Configuration
extension SearchVC {
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

// MARK: - TextField Actions
extension SearchVC {
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
        if !viewModel.searchedPhotos.isEmpty {
            collection.setContentOffset(CGPoint(x: 0, y: -collection.contentInset.top), animated: true)
            viewModel.resetSearch()
            collection.reloadData()
        }
        textField.text = ""
        clearButton.isHidden = true
    }

    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension SearchVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - CollectionView DataSource & Delegate
extension SearchVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.searchedPhotos.isEmpty ? viewModel.photos.count : viewModel.searchedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let photo: Photo = viewModel.searchedPhotos.isEmpty ? viewModel.photos[indexPath.item] : viewModel.searchedPhotos[indexPath.item]

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
            let vc = self.storyboard?.instantiateViewController(identifier: "\(TopicVC.self)") as! TopicVC
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
        if viewModel.isSearching {
            if let query = textField.text, !query.isEmpty {
                viewModel.pagination(index: indexPath.item, query: query)
            }
        } else {
            viewModel.pagination(index: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "\(PhotoDetailVC.self)") as! PhotoDetailVC
        let photo: Photo = viewModel.searchedPhotos.isEmpty ? viewModel.photos[indexPath.item] : viewModel.searchedPhotos[indexPath.item]
        vc.photoURL = photo.urls.raw
        vc.username = photo.user.name
        vc.photoId = photo.id
        vc.altDescription = photo.altDescription
        vc.hidesBottomBarWhenPushed = true
        navigationController?.show(vc, sender: nil)
    }
}

// MARK: - Button Actions
extension SearchVC {
    @IBAction func searchButtonTapped(_ sender: Any) {
        if let text = textField.text, !text.isEmpty {
            collection.setContentOffset(CGPoint(x: 0, y: -collection.contentInset.top), animated: true)
            view.endEditing(true)
            viewModel.resetSearch()
            viewModel.isSearching = true
            viewModel.getSearchedPhotos(query: text)
        } else {
            viewModel.resetSearch()
            collection.reloadData()
        }
    }
}
