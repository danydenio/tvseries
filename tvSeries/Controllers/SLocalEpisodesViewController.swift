//
//  SLocalEpisodesViewController.swift
//  tvSeries
//
//  Created by mobile consulting on 12/8/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import UIKit
protocol TabBarItemChangedProtocol: class {
    func barHasChanged() -> Void
}

class SLocalEpisodesViewController: UIViewController {
    var serieDataManager: SerieDataManager?
    var serieLocal: Serie?
    var delegateCell: DelegateCellDownloadButton?
    let serieEntity = SerieDataPersistanceManager()
    @IBOutlet weak var customView: SEpisodesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(hue: 0, saturation: 0, brightness: 0.09, alpha: 1.0)
        customView.backgroundColor = color
        customView.tableView.backgroundColor = color
        initTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let tab = self.tabBarController as? EpisodesTabBarController {
            tab.initializeLocalData()
            serieLocal = tab.localSerieData
            customView.tableView.reloadData()
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

extension SLocalEpisodesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.segueIdentifierEpisodeLocal, sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.segueIdentifierEpisodeLocal {
            if let nextViewController = segue.destination as? EpisodeViewController, let indexPath = customView.tableView.indexPathForSelectedRow, let seasons = self.serieLocal?.seasons, var episodes = seasons[indexPath.section].episodes {
                nextViewController.episode = episodes[indexPath.row]
            }
        }
    }
}

extension SLocalEpisodesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = self.serieLocal?.seasons?.count {
            return sections
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let seasons = self.serieLocal?.seasons, let episodes = seasons[section].episodes  {
            print(episodes.count)
            return episodes.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let seasons = self.serieLocal?.seasons {
            return "Season \(seasons[section].season)"
        }
        return ""
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = customView.tableView.dequeueReusableCell(withIdentifier: SEpisodeTableViewCell.nibName, for: indexPath) as? SEpisodeTableViewCell, let seasons = self.serieLocal?.seasons, let episodes = seasons[indexPath.section].episodes {
            cell.bindNormalCell(episode: episodes[indexPath.row])            
            cell.buttonDownload.setBackgroundImage(#imageLiteral(resourceName: "custom_trash_1"), for: .normal)
            cell.delegateCell = self
            cell.indexPath = indexPath
            return cell
        }
        return UITableViewCell()
    }
}

extension SLocalEpisodesViewController: DelegateCellDownloadButton {
    func didPressDownload(index: IndexPath, sender: LoadingButton) {
        guard let serie = serieLocal, let season = serie.seasons?[index.section], let episode = season.episodes?[index.row] else {
            return
        }
        sender.showLoading()
        let deleted = serieEntity.deleteEpisodeSeasonSerieIfExists(episode: episode)
        if deleted {
            if let tab = self.tabBarController as? EpisodesTabBarController {
                tab.initializeLocalData()                
                serieLocal = tab.localSerieData
                customView.tableView.reloadData()
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false){_ in
            sender.hideLoading()
        }
    }
}
