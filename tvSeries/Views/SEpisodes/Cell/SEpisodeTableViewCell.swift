//
//  SEpisodeTableViewCell.swift
//  tvSeries
//
//  Created by mobile consulting on 12/8/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import UIKit

protocol DelegateCellDownloadButton: class {
    func didPressDownload(index: IndexPath, sender: LoadingButton)
}

class SEpisodeTableViewCell: UITableViewCell {
    static let nibName = "SEpisodeTableViewCell"
    @IBOutlet weak var imageViewEpisode: UIImageView!
    @IBOutlet weak var labelPlot: UILabel!    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelRuntime: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var buttonDownload: LoadingButton!
    var delegateCell: DelegateCellDownloadButton?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let color = UIColor(hue: 0, saturation: 0, brightness: 0.09, alpha: 1.0)
        self.contentView.backgroundColor = color
        self.backgroundColor = color
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(hue: 0.0056, saturation: 0, brightness: 0.27, alpha: 1.0)
        self.selectedBackgroundView = bgColorView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func bindNormalCell(episode: Episode, flagEpisodeExists: Bool = false) {
        imageViewEpisode.clipsToBounds = true
        accessoryType = .disclosureIndicator        
        if flagEpisodeExists {
            buttonDownload.setBackgroundImage(#imageLiteral(resourceName: "custom_trash_1"), for: .normal)
        } else {
            buttonDownload.setBackgroundImage(#imageLiteral(resourceName: "custom_download_2") , for: .normal)
        }
        labelTitle.text =  episode.title
        labelRating.text = episode.imdbRating + "/10"
        if let runtime = episode.runtime {
            labelRuntime.text = runtime
        }
        if let plot = episode.plot {
            labelPlot.text = plot
        }
        if let url = episode.poster {
            imageViewEpisode.loadImageUsingCacheWithUrl(url: url)
        }
    }
    @IBAction func didPressDownloadButton(_ sender: LoadingButton) {
        delegateCell?.didPressDownload(index: indexPath!, sender: sender)
    }
    
}
