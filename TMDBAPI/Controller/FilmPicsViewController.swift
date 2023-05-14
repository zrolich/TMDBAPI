//
//  FilmPicsViewController.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 31.01.2023.
//

import UIKit
import RealmSwift

class FilmPicsViewController: UIViewController {
    
    let filmCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$КОЛ-ВО$ кадров"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = false
        collectionView.register(FilmPicsViewCell.self, forCellWithReuseIdentifier: String(describing: FilmPicsViewCell.self))
        
        return collectionView
    }()
    
    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(filmCountLabel)
        collectionView.backgroundColor = .white
        
        setConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setConstraints(){
        
        NSLayoutConstraint.activate([
            filmCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            filmCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filmCountLabel.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
}

extension FilmPicsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.frame.width*0.85,
            height: collectionView.frame.height
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        временные данные
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilmPicsViewCell.self), for: indexPath) as? FilmPicsViewCell else {
            return UICollectionViewCell()
        }
        //        временные данные
        cell.filmPicsViewImage.image = UIImage(named: model.mainFilmObject?[indexPath.row].filmPic ?? "image5")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FullPicViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
