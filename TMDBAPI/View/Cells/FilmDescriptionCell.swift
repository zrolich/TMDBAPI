//
//  FilmDescribingCell.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 28.02.2023.
//

import UIKit
import RealmSwift

class FilmDescriptionCell: UICollectionViewCell {
    
    var filmFramesImage: UIImageView = {
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
        contentView.addSubview(filmFramesImage)
        
        filmFramesImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        filmFramesImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        filmFramesImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        filmFramesImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
