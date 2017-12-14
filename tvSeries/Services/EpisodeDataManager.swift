//
//  SeasonDataPersistanceManager.swift
//  tvSeries
//
//  Created by mobile consulting on 12/10/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import Foundation
import CoreData
class SerieDataManager: DataPersitanceManager {
    var imdbID: String
    var serie: Serie?
    var dictionaryEpisodes: [String: Bool]?
    var episodeDataManager = EpisodeDataManager()
    
    init(imdbID: String) {
        self.imdbID = imdbID
        super.init()
    }
    func initializeSerieInformation() -> Bool {
        let series = findSerie(imdbIDs: self.imdbID)
        print(episodeDataManager.getAllEpisodes())
        if let serieEntity = series.first, let serie = convertSerie(serieEntity: serieEntity) {
            //Cannot assign to property: 'serie' is a 'let' constant
            let (dictionarySeasons, dictionaryEpisodes) = episodeDataManager.getDictionarySeasonsEpisodesBySerieId(seriesID: serie.imdbID)
            self.dictionaryEpisodes = dictionaryEpisodes
            print(dictionaryEpisodes)
            self.serie = serie
            self.serie?.seasons = episodeDataManager.getSeasonsWithEpisodesFromDictionary(dictionary: dictionarySeasons, serie: serie)
            return true
        }
        
        return false
        
    }
    private func convertSerie(serieEntity: SerieEntity) -> Serie? {
        if let title = serieEntity.title, let imdbID  = serieEntity.imdbID, let year  = serieEntity.year, let rated  = serieEntity.rated, let released  = serieEntity.released, let runtime  = serieEntity.runtime, let genre  = serieEntity.genre, let plot  = serieEntity.plot , let poster  = serieEntity.poster , let posterURL = URL(string: poster), let imdbRating  = serieEntity.imdbRating , let imdbVotes  = serieEntity.imdbVotes, let totalSeasons = serieEntity.totalSeasons {
            
            let serie = Serie(title: title, imdbID: imdbID, year: year, rated: rated, released: released, runtime: runtime, genre: genre, plot: plot, poster: posterURL, imdbRating: imdbRating, imdbVotes: imdbVotes, totalSeasons: totalSeasons)
            return serie
        }
        return nil
    }
    
    func findSerie(imdbIDs: String) -> ([SerieEntity]) {
        var serieEntitysArray = [SerieEntity]()
        let context = getContext()
        let fetchRequest: NSFetchRequest<SerieEntity> = SerieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID in %@", [imdbIDs])
        do {
            let searchResults = try context.fetch(fetchRequest)
            for item in searchResults {
                serieEntitysArray.append(item)
                break
            }
        } catch let error as NSError {
            print(error)
        } catch {
            print("Other error")
        }
        return serieEntitysArray
    }
    
}

class EpisodeDataManager: DataPersitanceManager {
    func convertEpisodes(episodesEntities: [EpisodeEntity])  -> [Episode] {
        var episodes = [Episode]()
        for episodeEntity in episodesEntities {
            if let episode = convertEpisode(episodeEntity: episodeEntity) {
                episodes.append(episode)
            }
        }
        return episodes
    }
    func convertEpisode(episodeEntity: EpisodeEntity) -> Episode? {
        if let title = episodeEntity.title, let released = episodeEntity.released, let episode = episodeEntity.episode, let imdbRating = episodeEntity.imdbRating, let imdbID = episodeEntity.imdbID, let poster = episodeEntity.poster, let posterURL = URL(string: poster), let seriesID = episodeEntity.seriesID, let seasonNumber = episodeEntity.seasonNumber {
            let episode = Episode(title: title, released: released, episode: episode, imdbRating: imdbRating, imdbID: imdbID, poster: posterURL, plot: episodeEntity.plot, runtime: episodeEntity.runtime, saved: true, seriesID: seriesID, seasonNumber: seasonNumber)
            return episode
            //print(episode)
        }
        return nil
    }
    func getAllEpisodes() -> [Episode] {
        let fetchRequest: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        var episodes: [Episode] = []
        do {
            let episodesEntities = try getContext().fetch(fetchRequest)
            episodes = convertEpisodes(episodesEntities: episodesEntities)
            
        } catch let error {
            print(error)
        }
        return episodes
    }
    func getDictionarySeasonsEpisodesBySerieId(seriesID: String) -> ([String: [Episode]], [String: Bool]){
        let context = getContext()
        let fetchRequest: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        var dictionarySeasons = [String: [Episode]]()
        var dictionaryEpisodes = [String: Bool]()
        fetchRequest.predicate = NSPredicate(format: "seriesID == %@", seriesID)
        let sortDescriptor = NSSortDescriptor(key: "episode", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors

        
        do {
            let searchResults = try context.fetch(fetchRequest)
            
            for item in searchResults {
                if let episode = convertEpisode(episodeEntity: item), let seasonNumber = episode.seasonNumber {
                    if dictionarySeasons[seasonNumber] == nil {
                        dictionarySeasons[seasonNumber] = [episode]
                    } else {
                        dictionarySeasons[seasonNumber]?.append(episode)
                    }
                    
                    if dictionaryEpisodes[episode.imdbID] == nil {
                        dictionaryEpisodes[episode.imdbID] = true
                    }
                }
            }
            
        } catch let error as NSError {
            print(error)
        } catch {
            print("Other error")
        }
        return (dictionarySeasons, dictionaryEpisodes)
    }
    func getSeasonsWithEpisodesFromDictionary(dictionary: [String: [Episode]], serie: Serie) -> [Season] {
        var seasons = [Season]()
        for (season, episodes) in dictionary {
            var episodesArray = [Episode]()
            for episode in episodes {
                episodesArray.append(episode)
            }
            seasons.append(Season(season: season, serieID: serie.imdbID, serie: serie, episodes: episodesArray))
        }
        return seasons
    }
}

