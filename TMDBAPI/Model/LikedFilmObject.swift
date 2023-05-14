//
//  LikedFilmObject.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 14.04.2023.
//

import Foundation
import RealmSwift

class LikedFilmObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var filmPic: String = ""
    @objc dynamic var filmTitle: String = ""
    @objc dynamic var about: String = ""
    @objc dynamic var releaseYear: Int = 0
    @objc dynamic var filmRating: Double = 0
    dynamic var screens: List<String> = List<String>()
    @objc dynamic var isLikedByUser: Bool = false
    
    override class func primaryKey() -> String {
        return "id"
    }
    
}
