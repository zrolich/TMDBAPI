//
//  JSONParsingService.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 14.04.2023.
//

import Foundation
import RealmSwift

class JSONParsingService {
    
    func parceJSON(parseData: Data, parceError: Error?){
        do {
            let filmObject = try JSONDecoder().decode(MovieList.self, from: parseData)
            let jsonObjects = filmObject.results
            let realm = try? Realm()
            
            try? realm?.write({
                for item in jsonObjects {
                    let object = FilmObject()
                    
                    if let unwrID = item.id,
                       let unwrPoster = item.poster_path,
                       let unwrOrigTitle = item.original_title,
                       let unwrAbout = item.overview,
                       let unwrReleaseYear = item.release_date,
                       let unwrFilmRating = item.vote_average{
                        object.id = unwrID
                        object.filmPic = unwrPoster
                        object.filmTitle = unwrOrigTitle
                        object.about = unwrAbout
                        object.releaseYear = Int(unwrReleaseYear.prefix(4)) ?? 0000
                        object.filmRating = unwrFilmRating
//                        object.screens = item.backdrop_path ?? "N/A"
                        object.isLikedByUser = false
                    }
                    realm?.add(object, update: .all)
                }
            })
        } catch let error {
            print(error)
        }
    }
}
