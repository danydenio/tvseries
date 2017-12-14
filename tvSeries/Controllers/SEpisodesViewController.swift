//
//  SEpisodesViewController.swift
//  tvSeries
//
//  Created by mobile consulting on 12/8/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class SEpisodesViewController: UIViewController {
    @IBOutlet weak var customView: SEpisodesView!
    var networkManager: SerieNetworkManagerService?
    var delegateCell: DelegateCellDownloadButton?
    let serieEntity = SerieDataPersistanceManager()
    var existingEpisodesDictionary: [String: Bool]?
    var myTab: EpisodesTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        customView.contentView.backgroundColor = UIColor.blue        
        let color = UIColor(hue: 0, saturation: 0, brightness: 0.09, alpha: 1.0)
        customView.backgroundColor = color
        customView.tableView.backgroundColor = color
        if let tab = self.tabBarController as? EpisodesTabBarController {
            myTab = tab
            networkManager = SerieNetworkManagerService(imdbID: tab.imdbIDSerie)
            self.existingEpisodesDictionary = tab.existingEpisodesDictionary
            networkManager?.delegate = self
            networkManager?.initializeSerieInformation()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if let tab = self.tabBarController as? EpisodesTabBarController {            
            tab.initializeLocalData()
            self.existingEpisodesDictionary = tab.existingEpisodesDictionary
            self.customView.tableView.reloadData()
        }
    }
    fileprivate func initTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        customView.tableView.estimatedRowHeight = 222
        customView.tableView.rowHeight = UITableViewAutomaticDimension
        customView.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        customView.tableView.estimatedSectionHeaderHeight = 30;
        customView.tableView.register(UINib(nibName: SEpisodeTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: SEpisodeTableViewCell.nibName)
    }
}

// MARK: NetworkManagerDelegate
extension SEpisodesViewController: NetworkManagerDelegate {
    func didDownloadRequest() -> Void {
        customView.tableView.reloadData()
    }
}

// MARK: UITableViewDelegate
extension SEpisodesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.segueIdentifierEpisodeAPI, sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.segueIdentifierEpisodeAPI {
            if let nextViewController = segue.destination as? EpisodeViewController, let indexPath = customView.tableView.indexPathForSelectedRow, let seasons = networkManager?.serie?.seasons, var episodes = seasons[indexPath.section].episodes{
                nextViewController.episode = episodes[indexPath.row]
                
            }
        }
    }
}
// MARK: UITableViewDataSource
extension SEpisodesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = networkManager?.serie?.seasons?.count {
            return sections
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let seasons = networkManager?.serie?.seasons, let episodes = seasons[section].episodes  {
            return episodes.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if let seasons = networkManager?.serie?.seasons  {
            return "Season \(seasons[section].season)"
        }
        return ""
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = customView.tableView.dequeueReusableCell(withIdentifier: SEpisodeTableViewCell.nibName, for: indexPath) as? SEpisodeTableViewCell, let seasons = networkManager?.serie?.seasons, var episodes = seasons[indexPath.section].episodes {
            var exists = false
            if let dictionary = existingEpisodesDictionary, dictionary[episodes[indexPath.row].imdbID] != nil {
                exists = true
                networkManager?.serie?.seasons?[indexPath.section].episodes?[indexPath.row].saved = true
                
            }
            cell.bindNormalCell(episode: episodes[indexPath.row], flagEpisodeExists: exists)
            cell.delegateCell = self
            cell.indexPath = indexPath
            return cell
        }
        
        
        return UITableViewCell()
    }
}
// MARK: DelegateCellDownloadButton
extension SEpisodesViewController: DelegateCellDownloadButton {
    func didPressDownload(index: IndexPath, sender: LoadingButton) {
        guard let serie = networkManager?.serie, let season = serie.seasons?[index.section], var episode = season.episodes?[index.row], let exists = episode.saved else {
            return
        }
        sender.showLoading()
        if !exists {
            networkManager?.serie?.seasons?[index.section].episodes?[index.row].saved = true
            serieEntity.storeEpisodeWithSeasonSerieIfDontExists(episode: episode) { (result) in
                switch result {
                case .success(let resultSuccess):
                    episode.saved = true
                    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false){_ in
                        sender.hideLoading()
                    }
                    self.myTab?.initializeLocalData()
                    self.existingEpisodesDictionary = self.myTab?.existingEpisodesDictionary
                case .failure(let error):
                    print(error)
                }
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false){_ in
                    sender.hideLoading()
                }
            }
        } else {
            networkManager?.serie?.seasons?[index.section].episodes?[index.row].saved = false
            serieEntity.deleteEpisodeSeasonSerieIfExists(episode: episode)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false){_ in
                sender.hideLoading()
            }
        }
    }
}
