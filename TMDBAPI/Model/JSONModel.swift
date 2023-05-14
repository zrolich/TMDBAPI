//
//  JSONModel.swift
//  TMDBAPI
//
//  Created by Zhanna Rolich on 12.04.2023.
//

import Foundation

class MovieList: Codable {
    let page: Int
    let total_results: Int?
    let total_pages: Int?
    let results: [Result]
}

class Result: Codable {
    var id: Int?
    var poster_path: String?
    var original_title: String?
    var overview: String?
    var release_date: String?
    var vote_average: Double?
    var backdrops: [Backdrop]?
}

class Backdrop: Codable {
    var aspect_ratio: Double?
    var height: Int
    var file_path: String?
    var width: Int
}
