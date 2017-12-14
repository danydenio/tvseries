//
//  Serie.swift
//  tvSeries
//
//  Created by mobile consulting on 12/9/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import Foundation


struct Serie: Codable {
    var title: String
    var imdbID: String
    var year: String
    var rated: String
    var released: String
    var runtime: String
    var genre: String
    var plot: String?
    var poster: URL
    var imdbRating: String?
    var imdbVotes: String?
    var totalSeasons: String
    var seasons: [Season]?
    
    init (title: String, imdbID: String, year: String, rated: String, released: String, runtime: String, genre: String, plot: String?, poster: URL, imdbRating: String? = nil, imdbVotes: String? = nil, totalSeasons: String, seasons: [Season]? = nil) {
        self.title = title
        self.imdbID  = imdbID
        self.year  = year
        self.rated  = rated
        self.released  = released
        self.runtime  = runtime
        self.genre  = genre
        self.plot  = plot
        self.poster  = poster
        self.imdbRating  = imdbRating
        self.imdbVotes  = imdbVotes
        self.totalSeasons  = totalSeasons
        self.seasons  = seasons 
    }
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case imdbID 
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case plot = "Plot"
        case poster = "Poster"
        case imdbRating
        case imdbVotes
        case totalSeasons
        case seasons
    }
}


