//
//  EpisodesTabBarController.swift
//  tvSeries
//
//  Created by mobile consulting on 12/10/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import UIKit

class EpisodesTabBarController: UITabBarController, UITabBarControllerDelegate {
    var localSerieData: Serie?
    var existingEpisodesDictionary: [String: Bool]?
    var coreDataSerieManagement = SerieDataPersistanceManager()
    var serieDataManager: SerieDataManager?
    var imdbIDSerie = "tt0944947"
    weak var delegateTabBar: TabBarItemChangedProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = .black
        self.delegate = self
        initializeLocalData()
    }
    func initializeLocalData() {
        serieDataManager = SerieDataManager(imdbID: imdbIDSerie)
        if let flag = serieDataManager?.initializeSerieInformation(), flag {
            localSerieData = serieDataManager?.serie
            self.existingEpisodesDictionary = serieDataManager?.dictionaryEpisodes
        }
    }
}
