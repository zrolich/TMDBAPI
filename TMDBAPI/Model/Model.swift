//
//  Model.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 15.03.2023.
//

import Foundation
import RealmSwift

class Model {
    let realm = try? Realm()
    var filmObjects: Results<FilmObject>? {
        return realm?.objects(FilmObject.self)
    }
    var mainFilmObject: Results<FilmObject>?
    var likedFilmObjects: Results<FilmObject>?
    var sortAscending: Bool = false
    
    func showLikedFilms(){
        let likeFilter = NSPredicate(format: "isLikedByUser = true")
        
        likedFilmObjects = filmObjects?.filter(likeFilter)
    }
    
    func updateLike(at item: Int){
        if let film  = filmObjects?[item] {
            do{
                try realm?.write {
                    film.isLikedByUser = !film.isLikedByUser
                }
            }catch {
                print("Error saving done status, \(error)")
            }
        }
    }
    
    func ratingSort() {
        mainFilmObject = filmObjects?.sorted(byKeyPath: "filmRating", ascending: sortAscending)
    }
    
    func search(searchTextValue: String){
       let predicate = NSPredicate(format: "filmTitle CONTAINS [c]%@", searchTextValue)
        mainFilmObject = filmObjects?.filter(predicate)
    }
}


