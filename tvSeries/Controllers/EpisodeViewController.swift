//
//  EpisodeViewController.swift
//  tvSeries
//
//  Created by mobile consulting on 12/8/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelRunTime: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelVotes: UILabel!
    @IBOutlet weak var labelPlot: UILabel!
    var episode: Episode?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        let color = UIColor(hue: 0, saturation: 0, brightness: 0.09, alpha: 1.0)
        contentView.backgroundColor = color
        scrollView.backgroundColor = color
        if let ep = episode, let plot = ep.plot, let season = ep.seasonNumber {
            labelPlot.text = plot
            labelRating.text =  ep.imdbRating + "/10"
            labelRunTime.text = ep.runtime
            labelTitle.text = "S" + season + ":E" + ep.episode + " " + ep.title            
            if let url = ep.poster {
                imageView.loadImageUsingCacheWithUrl(url: url)
            }
            if let votes = ep.imdbVotes {
                labelVotes.text = "User ratings \(votes)"
            }
            else {
                labelVotes.isHidden = true
            }
        }
    }
}
