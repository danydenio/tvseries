//
//  SerieNetworkManagerService.swift
//  tvSeries
//
//  Created by mobile consulting on 12/8/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import Foundation

class SerieNetworkManagerService: NetworkManagerService {
    var urlComponents = URLComponents()
    var imdbID: String
    weak var delegate: NetworkManagerDelegate?
    var serie: Serie?
    init(imdbID: String) {
        self.imdbID = imdbID
        super.init()
        initUrl()
    }
    fileprivate func initUrl() {
        urlComponents.scheme = API.scheme
        urlComponents.host = API.host
        urlComponents.queryItems = [URLQueryItem(name: "apikey", value: API.apikey), URLQueryItem(name: "i", value: imdbID)]
    }
 
    func getEpisodes(season: Season, completion: ((Result<[Episode]>) -> Void)?) {
        var episodes = [Episode]()
        var loaded = 0
        guard let episodesIncomplete = season.episodes else {
            return
        }
        for episodeIncomplete in episodesIncomplete {
            self.urlComponents.queryItems = [URLQueryItem(name: "apikey", value: API.apikey), URLQueryItem(name: "i", value: episodeIncomplete.imdbID)]
            self.getRequest(urlComponents: self.urlComponents) { (result) in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    do {
                        var episode = try decoder.decode(Episode.self, from: response)
                        
                        episode.season = season
                        episode.saved = false
                        episode.season?.serie = season.serie
                        episodes.append(episode)
                        loaded = loaded + 1
                        if loaded == episodesIncomplete.count {
                            completion?(.success(episodes))
                        }
                    } catch let error {
                        print(error)
                        print("Error S")
                        completion?(.failure(error))
                    }
                case .failure(let error):
                    fatalError("error: \(error.localizedDescription)")
                }
                
            }
            
        }
    }
    
    func getSeasons(completion: ((Result<[Season]>) -> Void)?) {
        guard let serie = serie, let seasonsInt = Int(serie.totalSeasons) else {
            return
        }
        var seasons = [Season]()
        var loaded = 0
        let group = DispatchGroup()
        for i in 1 ... seasonsInt {
            group.enter()
            self.urlComponents.queryItems = [URLQueryItem(name: "apikey", value: API.apikey), URLQueryItem(name: "i", value: serie.imdbID), URLQueryItem(name: "season", value: "\(i)")]
            self.getRequest(urlComponents: self.urlComponents) { (result) in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    do {
                        var season = try decoder.decode(Season.self, from: response)                        
                        season.serie = serie
                        season.serieID = serie.imdbID
                        self.getEpisodes(season: season, completion: { (resultSeasons) in
                            switch resultSeasons {
                            case .success(let responseEpisodes):
                                season.episodes = responseEpisodes
                                season.episodes?.sort{ $1.episode > $0.episode}
                                seasons.append(season)
                                loaded = loaded + 1
                                print("Season \(season.season)")
                                print(loaded)
                                if loaded == seasonsInt {                                    
                                    completion?(.success(seasons))
                                }
                                group.leave()
                            case .failure(let error):
                                print("Error")
                                print(error)
                                completion?(.failure(error))
                            }
                        })
                        
                    } catch let error {
                        print("Error S")
                        print(error)
                    }
                case .failure(let error):
                    fatalError("error: \(error.localizedDescription)")
                }
            }
            group.wait()
        }
    }
    func initializeSerieInformation() {
        getRequest(urlComponents: urlComponents) { (result) in
            switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    do {
                        self.serie = try decoder.decode(Serie.self, from: response)
                        self.getSeasons(completion: { (resultSeasons) in
                            switch resultSeasons {
                            case .success(let responseS):
                                DispatchQueue.main.async {
                                    self.serie?.seasons = responseS
                                    self.serie?.seasons?.sort{ $1.season > $0.season}
                                    self.delegate?.didDownloadRequest()
                                }
                                
                            case .failure(let error):
                                print("Error")
                                print(error)
                            }
                        })
                    } catch {
                        print("Error")
                    }
            case .failure(let error):
                fatalError("error: \(error.localizedDescription)")
            }
        }
    }
}




