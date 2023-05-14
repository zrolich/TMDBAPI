//
//  DetailFilmViewController.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 31.01.2023.
//

import UIKit
import RealmSwift

class DetailFilmViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var receivedIndex: Int = Int()
    var transition: RoundingTransition = RoundingTransition()
    let heartBtnIcon: UIImage? = UIImage(systemName: "heart")
    let fillHeartBtnIcon: UIImage? = UIImage(systemName: "heart.fill")
    let model = Model()
    let service = URLService()
    var address = "https://image.tmdb.org/t/p/w500"
    
    let filmImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let filmName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    let filmYear: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    let filmRating: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.tintColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    let filmFrames: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Кадры, съемки"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lightGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = false
        collectionView.register(FilmDescriptionCell.self, forCellWithReuseIdentifier: String(describing: FilmDescriptionCell.self))
        
        return collectionView
    }()
    
    lazy var frameButton: UIButton = {
        let frameButton = UIButton()
        frameButton.translatesAutoresizingMaskIntoConstraints = false
        frameButton.setImage(UIImage(systemName: "arrowtriangle.right"), for: .normal)
        frameButton.tintColor = .black
        frameButton.backgroundColor = .lightGray
        frameButton.addTarget(self, action: #selector(frameBtnAct), for: .touchUpInside)
        frameButton.tag = 1
        
        return frameButton
    }()
    
    let filmDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Описание"
        label.numberOfLines = 0
        
        return label
    }()
    
    let filmDescriptionText: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.italicSystemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
    
        
        return textView
    }()
    
    var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try? Realm()
        let filmObject = FilmObject()
        
        configureStackView()
        setupViews()
        setConstraints()
        setDelegates()
        setGestureRecognizer()
        setDetails()
        updateLikedFilms()
        //model.ratingSort()
        
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(filmName)
        view.addSubview(filmImage)
        view.addSubview(stackView)
        view.addSubview(filmFrames)
        view.addSubview(collectionView)
        view.addSubview(frameButton)
        view.addSubview(filmDescription)
        view.addSubview(filmDescriptionText)
        
    }
    
    private func configureStackView() {
        stackView = UIStackView(arrangedSubviews: [filmYear, filmRating])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        stackView.alignment = .leading
    }
    
    private func setDelegates(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setGestureRecognizer(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureFired(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        
        filmImage.addGestureRecognizer(gestureRecognizer)
        filmImage.isUserInteractionEnabled = true
    }
    
    @objc func gestureFired(_ gester: UITapGestureRecognizer){
        let posterFullViewController = PosterFullViewController()
        posterFullViewController.modalPresentationStyle = .custom
        posterFullViewController.transitioningDelegate = self
        posterFullViewController.detailIndexPath = receivedIndex
        
        self.present(posterFullViewController, animated: true)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionProfile = .show
        transition.start = filmImage.center
        transition.roundColor = UIColor.white
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionProfile = .cancel
        transition.start = filmImage.center
        transition.roundColor = UIColor.lightGray
        
        return transition
    }
    
    func updateLikedFilms(){
        let likedButton = UIButton()
        likedButton.translatesAutoresizingMaskIntoConstraints = false
        likedButton.addTarget(self, action: #selector(self.favFilmBtnActn), for: .touchUpInside)
        
        DispatchQueue.main.async { [self] in
            if model.filmObjects?[self.receivedIndex].isLikedByUser == true {
                likedButton.setImage(self.fillHeartBtnIcon, for: .normal)
                likedButton.tintColor = .black
            } else {
                likedButton.setImage(heartBtnIcon, for: .normal)
                likedButton.tintColor = .black
            }
        }
        
        let rightBarLikedButtom = UIBarButtonItem(customView: likedButton)
        self.navigationItem.setRightBarButton(rightBarLikedButtom, animated: true)
    }
    
    
    @objc func favFilmBtnActn() {
        model.updateLike(at: receivedIndex)
        updateLikedFilms()
        
    }
    
    @objc func frameBtnAct(){
        let vc = FilmPicsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setDetails(){
        
        DispatchQueue.main.async {
            guard let unwrFilmPic = self.model.mainFilmObject?[self.receivedIndex].filmPic,
                  let posterURL = URL(string: self.address + unwrFilmPic) else {
                return
            }
            
            self.service.getSetPoster(url: posterURL){ image in
                self.filmImage.image = image
            }
            self.filmName.text = self.model.filmObjects?[self.receivedIndex].filmTitle
            self.filmYear.text = "Год выпуска: "+String(self.model.filmObjects?[self.receivedIndex].releaseYear ?? 0000)
            self.filmRating.text = "Рейтинг: "+String(self.model.filmObjects?[self.receivedIndex].filmRating ?? 0.0)
            self.filmDescriptionText.text = self.model.filmObjects?[self.receivedIndex].about
            
        }
    }
    
    private func setConstraints(){
        
        NSLayoutConstraint.activate([
            filmName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            filmName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            filmImage.topAnchor.constraint(equalTo: filmName.bottomAnchor, constant: 10),
            filmImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filmImage.widthAnchor.constraint(equalToConstant: 180),
            filmImage.heightAnchor.constraint(equalToConstant: 290)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: filmName.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: filmImage.trailingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            filmFrames.topAnchor.constraint(equalTo: filmImage.bottomAnchor, constant: 20),
            filmFrames.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filmFrames.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            frameButton.topAnchor.constraint(equalTo: filmFrames.bottomAnchor, constant: 10),
            frameButton.leadingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 0),
            frameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            frameButton.heightAnchor.constraint(equalTo: collectionView.heightAnchor),
            frameButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            filmDescription.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            filmDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            filmDescriptionText.topAnchor.constraint(equalTo: filmDescription.bottomAnchor, constant: 0),
            filmDescriptionText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            filmDescriptionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            filmDescriptionText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}

extension DetailFilmViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilmDescriptionCell.self), for: indexPath) as? FilmDescriptionCell else {
            return UICollectionViewCell()
        }
        //        временные данные
        cell.filmFramesImage.image = UIImage(named: model.filmObjects?[indexPath.row].filmPic ?? "image5")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.frame.width/3,
            height: collectionView.frame.width/3
        )
    }
}

extension DetailFilmViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
