//
//  Serie22.swift
//  tvSeries
//
//  Created by mobile consulting on 12/8/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import Foundation

class SerieModel {
    var imdbID: String
    var title: String?
    var year: String?
    var rated: String?
    var released: String?
    var runtime: String?
    var genre: String?
    var plot: String?
    var poster: URL?
    var imdbRating: Double?
    var imdbVotes: Int64?
    var totalSeasons: Int64?
    var season: Season?
    
    init(imdbID: String){
        self.imdbID = imdbID
    }
    init(title: String, year: String, rated: String, released: String, runtime: String, genre: String, plot: String, poster: URL, imdbRating: Double, imdbVotes: Int64, imdbID: String, totalSeasons: Int64) {
        self.title = title
        self.year = year
        self.rated = rated
        self.released = released
        self.runtime = runtime
        self.genre = genre
        self.plot = plot
        self.poster = poster
        self.imdbRating = imdbRating
        self.imdbVotes = imdbVotes
        self.imdbID = imdbID
        self.totalSeasons = totalSeasons
    }
}

//struct Serie {
//    var title: String
//    var imdbID: String
//
//
////    enum MyStructKeys: String, CodingKey { // declaring our keys
////        case title = "Title"
////        case imdbID
////    }
//}

//extension Serie: Decodable {
//        enum CodingKeys: String, CodingKey {
//            case title = "Title"
//            case imbdID
//        }
//
//}


