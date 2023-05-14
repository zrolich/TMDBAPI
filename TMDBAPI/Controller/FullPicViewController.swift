//
//  PosterFullViewController.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 15.03.2023.
//

import UIKit
import RealmSwift

class FullPicViewController: UIViewController {
    
    let model = Model()
    
    let filmCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "$НОМЕР/ОБЩЕЕ КОЛ-ВО$"
        label.numberOfLines = 1
        
        return label
    }()
    
    let fullPicImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image15")
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(filmCountLabel)
        view.addSubview(fullPicImage)
        
        setConstraints()
    }
    
    private func setConstraints(){
        
        NSLayoutConstraint.activate([
            filmCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            filmCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filmCountLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            fullPicImage.topAnchor.constraint(equalTo: filmCountLabel.bottomAnchor, constant: 10),
            fullPicImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            fullPicImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            fullPicImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
}
