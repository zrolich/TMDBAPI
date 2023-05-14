//
//  ViewController.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 31.01.2023.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FilmCell.self, forCellWithReuseIdentifier: String(describing: FilmCell.self))
        
        return collectionView
    }()
    
    let itemPerRow: CGFloat = 2
    let sectionInserts = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    let favBtnIcon: UIImage? = UIImage(systemName: "heart")
    let sortedBtnIcon: UIImage? = UIImage(systemName: "arrow.up.arrow.down")
    let sortedUpBtnIcon: UIImage? = UIImage(systemName: "arrow.up")
    let sortedDownBtnIcon: UIImage? = UIImage(systemName: "arrow.down")
    let model = Model()
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    let apiKey: String = "604c105ee1c166bcfc2ab13e732a355e"
    
    let session = URLSession.shared
    let service = URLService()
    let address = "https://image.tmdb.org/t/p/original"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try? Realm()
//        let filmObject = FilmObject()
        print(realm?.configuration.fileURL)
        
        model.ratingSort()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        setConstraints()
        setupDelegates()
        setNavigationItems()
        
        DispatchQueue.main.async {
            self.service.dataRequest()
            self.model.ratingSort()
            self.collectionView.reloadData()
            print("async complete")
        }
        collectionView.reloadData()
       
    }
    
    func dataRequest() {
        
        guard let apiURL: URL = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1") else {
            return
        }
        
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let unwrData = data,
                  let dataString = String(data: unwrData, encoding: .utf8),
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                return
            }
            print(dataString)
        }
        task.resume()
    }
    
    private func setupDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchController.searchBar.delegate = self
    }
    
    private func setNavigationItems() {
        searchController.searchBar.placeholder = "Введите название фильма"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        updateRightBarButton(isSortAscending: model.sortAscending)
    }
    
    func updateRightBarButton(isSortAscending : Bool){
        let favFilmBtn = UIBarButtonItem(image: favBtnIcon, style: .plain, target: self, action: #selector(favFilmBtnActn))
        favFilmBtn.tintColor = .black
        let sortBtn = UIButton()
        sortBtn.translatesAutoresizingMaskIntoConstraints = false
        sortBtn.tintColor = .black
        sortBtn.addTarget(self, action: #selector(self.sortedBtnActn), for: .touchUpInside)
        sortBtn.setImage(sortedBtnIcon, for: .normal)
        
        let rightSortButton = UIBarButtonItem(customView: sortBtn)
        self.navigationItem.setRightBarButtonItems([rightSortButton, favFilmBtn], animated: true)
    }
    
    @objc func favFilmBtnActn() {
        let vc = FavouriteFilmsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func sortedBtnActn() {
        model.sortAscending = !model.sortAscending
        
        model.ratingSort()
        updateRightBarButton(isSortAscending: model.sortAscending)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.mainFilmObject = model.filmObjects
        model.search(searchTextValue: searchText)
        
        if searchBar.text?.count == 0 {
            model.mainFilmObject = model.filmObjects
            model.ratingSort()
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        model.mainFilmObject = model.filmObjects
        
        if searchBar.text?.count == 0 {
            model.mainFilmObject = model.filmObjects
            model.ratingSort()
        }
        model.ratingSort()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInserts.left * (itemPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth/itemPerRow
        let heightPerItem = widthPerItem*1.55 + paddingWidth
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.mainFilmObject?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilmCell.self), for: indexPath) as? FilmCell,
              let item = model.mainFilmObject?[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.data = item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailFilmViewController()
        vc.receivedIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController {
    
    private func setConstraints() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
}
