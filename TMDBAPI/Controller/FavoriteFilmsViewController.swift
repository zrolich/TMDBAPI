//
//  FavoriteFilmsViewController.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 31.01.2023.
//

import UIKit
import RealmSwift

class FavouriteFilmsViewController: UIViewController {
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FavouriteFilmCell.self, forCellWithReuseIdentifier: String(describing: FavouriteFilmCell.self))
        
        return collectionView
    }()
    
    let itemPerRow: CGFloat = 2
    let sectionInserts = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        setConstraints()
        setupDelegates()
        model.showLikedFilms()
      
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(false)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func setupDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension FavouriteFilmsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInserts.left * (itemPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth/itemPerRow
        let heightPerItem = widthPerItem*1.65 + paddingWidth
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.likedFilmObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FavouriteFilmCell.self), for: indexPath) as? FavouriteFilmCell,
              let likedItem = model.likedFilmObjects?[indexPath.item] else {
            return UICollectionViewCell()
        }
        cell.data = likedItem
        cell.cellIndex = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailFilmViewController = DetailFilmViewController()
        detailFilmViewController.receivedIndex = model.likedFilmObjects?[indexPath.row].id ?? 0
        navigationController?.pushViewController(detailFilmViewController, animated: true)
    }
}

extension FavouriteFilmsViewController {
    
    private func setConstraints() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
}
