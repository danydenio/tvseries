//
//  SerieDataPersistanceManager.swift
//  tvSeries
//
//  Created by mobile consulting on 12/10/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import Foundation

//
//  CharacterDataPersistanceManager.swift
//  characterLocalSotre
//
//  Created by mobile consulting on 12/6/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataPersitanceManager {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate    
    func getContext() -> NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
}
class SerieDataPersistanceManager: DataPersitanceManager {
    func deleteEpisodeSeasonSerieIfExists(episode: Episode) -> Bool {
        guard let seriesID = episode.seriesID, let seasonNumber = episode.seasonNumber else {
            return false
        }
        let context = getContext()
        let existingEpisodesSeries = findEpisodesBySeriesID(seriesID: seriesID)
        print("Serie count")
        print(existingEpisodesSeries.count)
        if existingEpisodesSeries.count == 1 {
            context.delete(existingEpisodesSeries.first!)
            let existingSeason = findSeasonBySeriesID(seriesID: seriesID, season: seasonNumber)
            if existingSeason.count == 1 {
                context.delete(existingSeason.first!)
            }
        }
        let exsitingEpisode = findEpisodes(imdbIDs: [episode.imdbID])
        if exsitingEpisode.count == 1 {
            context.delete(exsitingEpisode.first!)
        }
        do {
            try context.save()
            return true
        } catch let error as NSError {
            print(error)
        } catch {
            print("Other error")
        }
        return false
    }
    func storeEpisode(episode: Episode) -> Bool {
        guard let season = episode.season, let serie = season.serie else {
            return false
        }
        if !storeSerie(serie: serie) && !storeSeason(season: season) {
            return false
        }
        let context = getContext()
        let episodeEntity = EpisodeEntity(context: context)
        episodeEntity.title = episode.title
        episodeEntity.released = episode.released
        episodeEntity.episode = episode.episode
        episodeEntity.imdbRating = episode.imdbRating
        episodeEntity.imdbID = episode.imdbID
        episodeEntity.poster = episode.poster?.absoluteString
        episodeEntity.plot = episode.plot
        episodeEntity.runtime = episode.runtime
        do {
            try context.save()
            return true
        } catch let error as NSError {
            print(error)
        } catch {
            print("Other error")
        }
        return false
        
    }
    
    func storeSerie(serie: Serie) -> Bool {
        let existingSeries = findSeries(imdbIDs: [serie.imdbID])
        if existingSeries.count > 0 {
            return true
        }
        let context = getContext()
        let serieEntity = SerieEntity(context: context)
        serieEntity.title = serie.title
        serieEntity.imdbID = serie.imdbID
        serieEntity.year = serie.year
        serieEntity.rated = serie.rated
        serieEntity.released = serie.released
        serieEntity.runtime = serie.runtime
        serieEntity.genre = serie.genre
        serieEntity.plot = serie.plot
        serieEntity.poster = serie.poster.absoluteString
        serieEntity.imdbRating = serie.imdbRating
        serieEntity.imdbVotes = serie.imdbVotes
        serieEntity.totalSeasons = serie.totalSeasons
        do {
            try context.save()
            return true
        } catch let error as NSError {
            print(error)
        } catch {
            print("Other error")
        }
        return false
    }
    func storeSeason(season: Season) -> Bool {
        let existingSeasons = findSeason(season: season)
        if existingSeasons.count > 0 {
            return true
        }
        let context = getContext()
        let seasonEntity = SeasonEntity(context: context)
        seasonEntity.season = season.season
        seasonEntity.serieID = season.serieID
        do {
            try context.save()
            return true
        } catch let error as NSError {
            print(error)
        } catch {
            print("Other error")
        }
        return false
    }
    func findSeries(imdbIDs: [String]) -> ([SerieEntity]) {
        var serieEntitysArray = [SerieEntity]()
        let context = getContext()
        let fetchRequest: NSFetchRequest<SerieEntity> = SerieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID in %@", imdbIDs)
        do {
            let searchResults = try context.fetch(fetchRequest)
            for item in searchResults {
                serieEntitysArray.append(item)
            }
        } catch let error as NSError {
            print(error)
        } catch {
            print("Other error")
        }
        return serieEntitysArray
    }
    func findSeason(season: Season) -> ([SeasonEntity] ) {
        var seasonEntityArray = [SeasonEntity]()
        guard let imdbID = season.serieID else {
            return seasonEntityArray
        }
        let context = getContext()
        let fetchRequest: NSFetchRequest<SeasonEntity> = SeasonEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", imdbID)
        fetchRequest.predicate = NSPredicate(format: "season == %@", season.season)
        do {
            let searchResults = try context.fetch(fetchRequest)
            for item in searchResults {
                seasonEntityArray.append(item)
            }
        } catch let error as NSError {
            print(error)
        } catch {
            print("Other error")
        }
        return seasonEntityArray
    }
    func findSeasonBySeriesID(seriesID: String, season: String) -> ([SeasonEntity] ) {
        var seasonEntityArray = [SeasonEntity]()
        let context = getContext()
        let fetchRequest: NSFetchRequest<SeasonEntity> = SeasonEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "serieID == %@", seriesID)
        fetchRequest.predicate = NSPredicate(format: "season == %@", season)
        do {
            let searchResults = try context.fetch(fetchRequest)
            for item in searchResults {
                seasonEntityArray.append(item)
            }
        } catch let error as NSError {
            print(error)
        } catch {
            print("Other error")
        }
        return seasonEntityArray
    }
    func findEpisodesBySeriesID(seriesID: String) -> ([EpisodeEntity]) {
        var serieEntitysArray = [EpisodeEntity]()
        let context = getContext()
        let fetchRequest: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "seriesID == %@", seriesID)
        do {
            let searchResults = try context.fetch(fetchRequest)
            for item in searchResults {
                serieEntitysArray.append(item)
            }
        } catch let error as NSError {
            print(error)
        } catch {
            print("Other error")
        }
        return serieEntitysArray
    }
    func findEpisodes(imdbIDs: [String]) -> ([EpisodeEntity]) {
        var serieEntitysArray = [EpisodeEntity]()
        let context = getContext()
        let fetchRequest: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID in %@", imdbIDs)
        do {
            let searchResults = try context.fetch(fetchRequest)
            for item in searchResults {
                serieEntitysArray.append(item)
            }
        } catch let error as NSError {
            print(error)
        } catch {
            print("Other error")
        }
        return serieEntitysArray
    }
    func storeEpisodeWithSeasonSerieIfDontExists(episode: Episode, completion: ((Result<Bool>) -> Void)?) {        
        guard let season = episode.season, let serie = season.serie else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Season or serie were unable to store"]) as Error
            completion?(.failure(error))
            return
        }
        if !self.storeSerie(serie: serie) || !self.storeSeason(season: season) {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
            completion?(.failure(error))
        }
        let context = getContext()
        let episodeEntity = EpisodeEntity(context: context)
        episodeEntity.title = episode.title
        episodeEntity.released = episode.released
        episodeEntity.episode = episode.episode
        episodeEntity.imdbRating = episode.imdbRating
        episodeEntity.imdbID = episode.imdbID
        episodeEntity.poster = episode.poster?.absoluteString
        episodeEntity.plot = episode.plot
        episodeEntity.seriesID = serie.imdbID
        episodeEntity.seasonNumber = episode.seasonNumber
        episodeEntity.runtime = episode.runtime
        do {
            try context.save()
                DispatchQueue.main.async {
                    completion?(.success(true))
                }
        } catch let error as NSError {
            completion?(.failure(error))
        }
    }
}

