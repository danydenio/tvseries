import Foundation

struct Episode: Codable {
    var title: String
    var released: String
    var episode: String
    var imdbRating: String
    var imdbID: String
    var poster: URL?
    var plot: String?
    var runtime: String?
    var saved: Bool?
    var season: Season?
    var seriesID: String?
    var seasonNumber: String?
    var imdbVotes: String?
    
    init(title: String, released: String, episode: String, imdbRating: String, imdbID: String, poster: URL? = nil, plot: String? = nil, runtime: String? = nil, saved: Bool? = nil, season: Season? = nil, seriesID: String? = nil, seasonNumber: String? = nil, imdbVotes: String? = nil) {
        self.title = title
        self.released = released
        self.episode = episode
        self.imdbRating = imdbRating
        self.imdbID = imdbID
        self.poster = poster
        self.plot = plot
        self.runtime = runtime
        self.saved = saved
        self.season = season
        self.seriesID = seriesID
        self.seasonNumber = seasonNumber
        self.imdbVotes = imdbVotes
    }
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case released = "Released"
        case episode = "Episode"
        case imdbRating
        case imdbID
        case poster = "Poster"
        case plot = "Plot"
        case runtime = "Runtime"
        case saved
        case season
        case seriesID
        case seasonNumber = "Season"
        case imdbVotes
    }
}
