//
//  FullPicViewController.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 31.01.2023.
//

import UIKit
import RealmSwift

class PosterFullViewController: UIViewController {
    
    var detailIndexPath: Int = Int()
    let model = Model()
    let service = URLService()
    var address = "https://image.tmdb.org/t/p/w500"
    
    let filmImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeBtnActn), for: .touchUpInside)
        closeButton.tag = 1
        
        return closeButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(filmImage)
        view.addSubview(closeButton)
        setConstraints()
        
        guard let unwrFilmPic = self.model.filmObjects?[self.detailIndexPath].filmPic,
              let posterURL = URL(string: self.address + unwrFilmPic) else {
            return
        }
        service.getSetPoster(url: posterURL){ image in
            self.filmImage.image = image
        }
    }
    
  @objc func closeBtnActn() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setConstraints(){
        
        NSLayoutConstraint.activate([
            filmImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            filmImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            filmImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            filmImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}
