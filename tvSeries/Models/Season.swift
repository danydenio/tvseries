//
//  Season.swift
//  tvSeries
//
//  Created by mobile consulting on 12/8/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import Foundation

struct Season: Codable {
    var season: String
    var serieID: String?
    var serie: Serie?
    var episodes: [Episode]?
    
    enum CodingKeys: String, CodingKey {
        case season = "Season"
        case episodes = "Episodes"
        case serie
        case serieID
    }
    init(season: String, serieID: String, serie: Serie? = nil, episodes: [Episode]? = nil) {
        self.season = season
        self.serieID = serieID
        self.serie = serie
        self.episodes = episodes
    }
}
