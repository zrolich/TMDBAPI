//
//  FilmPicsViewCell.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 29.03.2023.
//

import UIKit
import RealmSwift

class FilmPicsViewCell: UICollectionViewCell {
    
    var filmPicsViewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "image1")
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        contentView.addSubview(filmPicsViewImage)
        
        filmPicsViewImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        filmPicsViewImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        filmPicsViewImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        filmPicsViewImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
