//
//  FilmCell.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 08.02.2023.
//

import UIKit
import RealmSwift

class FilmCell: UICollectionViewCell {
    
    private enum Constants {
        
        static let imageHeight: CGFloat = 236.5
        static let horizontalSpacing: CGFloat = 15.0
        static let verticalSpacing: CGFloat = 3.0
        
    }
    
    let filmImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let filmName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    let filmYearAndRating: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    let urlService = URLService()
    var address = "https://image.tmdb.org/t/p/w500"
    var data: FilmObject? {
        
        didSet {
            guard let unwrData = data, let url = URL(string: address + unwrData.filmPic) else {
                return
            }
            
            urlService.getSetPoster(url: url){ image in
                self.filmImage.image = image
            }
            filmName.text = unwrData.filmTitle
            filmYearAndRating.text = String(unwrData.releaseYear)+", "+String(unwrData.filmRating)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemCyan
        
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        
        contentView.addSubview(filmImage)
        contentView.addSubview(filmName)
        contentView.addSubview(filmYearAndRating)
        
    }
    
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            filmImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            filmImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            filmImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            filmImage.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])
        
        NSLayoutConstraint.activate([
            filmName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            filmName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            filmName.topAnchor.constraint(equalTo: filmImage.bottomAnchor, constant: Constants.verticalSpacing)
        ])
        
        NSLayoutConstraint.activate([
            filmYearAndRating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            filmYearAndRating.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            filmYearAndRating.topAnchor.constraint(equalTo: filmName.bottomAnchor, constant: Constants.verticalSpacing)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
